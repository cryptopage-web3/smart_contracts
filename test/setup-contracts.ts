import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;

let version = 1;
let ruleList, pluginList;

export default async function setupContracts() {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;

    let registry, executor;
    let contractBlank;

    let bank, oracle, token, nft, soulBound, rule;
    let dao = AddressZero;
    let treasury;
    let communityData, postData, commentData;

    let firstCommunityName = "First community";
    let secondCommunityName = "Second community";

    [owner, creator, third] = await getSigners();

    const registryFactory = await ethers.getContractFactory("contracts/registry/Registry.sol:Registry");
    registry = await registryFactory.deploy();
    await registry.deployed();
    treasury = registry.address;
    await registry.initialize(dao, treasury);

    const nftFactory = await ethers.getContractFactory("contracts/tokens/nft/NFT.sol:NFT");
    nft = await nftFactory.deploy();
    await nft.initialize(registry.address, 8, "https://nft.page");
    await registry.setNFT(nft.address);

    const accountFactory = await ethers.getContractFactory("contracts/account/Account.sol:Account");
    let account = await accountFactory.deploy();
    await account.initialize(registry.address);
    await registry.setAccount(account.address);

    const ruleListFactory = await ethers.getContractFactory("contracts/rules/community/RulesList.sol:RulesList");
    ruleList = await ruleListFactory.deploy();

    const pluginsListFactory = await ethers.getContractFactory("contracts/plugins/PluginsList.sol:PluginsList");
    pluginList = await pluginsListFactory.deploy();

    const communityDataFactory = await ethers.getContractFactory("contracts/community/CommunityData.sol:CommunityData");
    communityData = await communityDataFactory.deploy();
    await communityData.initialize(registry.address);
    await registry.setCommunityData(communityData.address);

    const postDataFactory = await ethers.getContractFactory("contracts/community/PostData.sol:PostData");
    postData = await postDataFactory.deploy();
    await postData.initialize(registry.address);
    await registry.setPostData(postData.address);

    const commentDataFactory = await ethers.getContractFactory("contracts/community/CommentData.sol:CommentData");
    commentData = await commentDataFactory.deploy();
    await commentData.initialize(registry.address);
    await registry.setCommentData(commentData.address);

    const executorFactory = await ethers.getContractFactory("contracts/executor/Executor.sol:Executor");
    executor = await executorFactory.deploy();
    await executor.initialize(registry.address);
    await registry.setExecutor(executor.address);

    const tokenFactory = await ethers.getContractFactory("contracts/tokens/token/Token.sol:Token");
    token = await tokenFactory.deploy();
    await token.initialize(registry.address);
    await registry.setToken(token.address);

    const bankFactory = await ethers.getContractFactory("contracts/bank/Bank.sol:Bank");
    bank = await bankFactory.deploy();
    await bank.initialize(registry.address);
    await registry.setBank(bank.address);

    const oracleFactory = await ethers.getContractFactory("contracts/bank/Oracle.sol:Oracle");
    oracle = await oracleFactory.deploy();
    await oracle.initialize(registry.address);
    await registry.setOracle(oracle.address);

    const soulBoundFactory = await ethers.getContractFactory("contracts/tokens/soulbound/SoulBound.sol:SoulBound");
    soulBound = await soulBoundFactory.deploy();
    await soulBound.initialize(registry.address);
    await registry.setSoulBound(soulBound.address);

    const blankFactory = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
    contractBlank = await blankFactory.deploy();

    const ruleFactory = await ethers.getContractFactory("contracts/rules/Rule.sol:Rule");
    rule = await ruleFactory.deploy();
    await rule.initialize();
    await registry.setRule(rule.address);

    await setupCommonPlugins(registry, owner);
    await setupCommonRules(registry, rule);

    let id = ethers.utils.formatBytes32String("1");
    let data = defaultAbiCoder.encode([ "string", "bool" ], [firstCommunityName, true ]);
    await executor.connect(owner).run(id, pluginList.COMMUNITY_CREATE(), version, data);

    id = ethers.utils.formatBytes32String("101");
    data = defaultAbiCoder.encode([ "string", "bool" ], [secondCommunityName, true ]);
    await executor.connect(owner).run(id, pluginList.COMMUNITY_CREATE(), version, data);

    let afterCount = await communityData.communitiesCount();
    let index = afterCount.sub(BigNumber.from(2));
    let createdCommunityAddress = await communityData.getCommunities(index, index);

    let communityBlank = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
    let createdCommunity = await communityBlank.attach(createdCommunityAddress[0]);

    let userVerificationRulesBlank = await ethers.getContractFactory("contracts/rules/community/UserVerificationRules.sol:UserVerificationRules");
    let userVerificationRules = await userVerificationRulesBlank.attach(await rule.getRuleContract(ruleList.USER_VERIFICATION_RULES(), version));
    await userVerificationRules.setFractalParams(treasury, "1 2 3");

    return {
        owner, creator, third,
        version, ruleList, pluginList,
        registry, rule, executor, bank,
        token, nft, soulBound,
        communityData, postData, commentData, account,
        createdCommunity
    };
}

async function setupCommonPlugins(_registryContract, user) {

    let pluginFactory = await ethers.getContractFactory("contracts/plugins/community/Create.sol:Create");
    let communityCreatePlugin = await pluginFactory.deploy(_registryContract.address, user.address);
    await communityCreatePlugin.deployed();
    await _registryContract.setPlugin(pluginList.COMMUNITY_CREATE(), version, communityCreatePlugin.address);

    await setupPlugin(_registryContract, "contracts/plugins/community/Join.sol:Join", pluginList.COMMUNITY_JOIN());
    await setupPlugin(_registryContract, "contracts/plugins/community/Quit.sol:Quit", pluginList.COMMUNITY_QUIT());
    await setupPlugin(_registryContract, "contracts/plugins/community/Info.sol:Info", pluginList.COMMUNITY_INFO());
    await setupPlugin(_registryContract, "contracts/plugins/community/EditModerators.sol:EditModerators", pluginList.COMMUNITY_EDIT_MODERATORS());

    await setupPlugin(_registryContract, "contracts/plugins/post/Write.sol:Write", pluginList.COMMUNITY_WRITE_POST());
    await setupPlugin(_registryContract, "contracts/plugins/post/Read.sol:Read", pluginList.COMMUNITY_READ_POST());
    await setupPlugin(_registryContract, "contracts/plugins/post/Burn.sol:Burn", pluginList.COMMUNITY_BURN_POST());
    await setupPlugin(_registryContract, "contracts/plugins/post/RePost.sol:RePost", pluginList.COMMUNITY_REPOST());
    // await setupPlugin(_registryContract, "contracts/plugins/post/ChangeVisibility.sol:ChangeVisibility", pluginList.COMMUNITY_CHANGE_VISIBILITY_POST());

    await setupPlugin(_registryContract, "contracts/plugins/comment/Write.sol:Write", pluginList.COMMUNITY_WRITE_COMMENT());
    await setupPlugin(_registryContract, "contracts/plugins/comment/Read.sol:Read", pluginList.COMMUNITY_READ_COMMENT());
    await setupPlugin(_registryContract, "contracts/plugins/comment/Burn.sol:Burn", pluginList.COMMUNITY_BURN_COMMENT());
}

async function setupPlugin(_registryContract, pathName, pluginName) {
    let pluginFactory = await ethers.getContractFactory(pathName);
    let pluginContract = await pluginFactory.deploy(_registryContract.address);
    await pluginContract.deployed();
    await _registryContract.setPlugin(pluginName, version, pluginContract.address);
}

async function setupCommonRules(_registryContract, _ruleContract) {
    let postAcceptingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.ACCEPTING_POST_RULES"])
    );
    let changeVisibilityRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.CHANGE_VISIBILITY_CONTENT_RULES"])
    );
    let gasCompensationRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.GAS_COMPENSATION_RULES"])
    );
    let advertisingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.ADVERTISING_PLACEMENT_RULES"])
    );
    let profitRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.PROFIT_DISTRIBUTION_RULES"])
    );
    let reputationRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.REPUTATION_MANAGEMENT_RULES"])
    );

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/CommunityJoiningRules.sol:CommunityJoiningRules", ruleList.COMMUNITY_JOINING_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/UserVerificationRules.sol:UserVerificationRules", ruleList.USER_VERIFICATION_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/PostCommentingRules.sol:PostCommentingRules", ruleList.POST_COMMENTING_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/PostPlacingRules.sol:PostPlacingRules", ruleList.POST_PLACING_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/PostReadingRules.sol:PostReadingRules", ruleList.POST_READING_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/PostTransferringRules.sol:PostTransferringRules", ruleList.POST_TRANSFERRING_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/ModerationRules.sol:ModerationRules", ruleList.MODERATION_RULES());

    await setupRule(_registryContract, _ruleContract,
        "contracts/rules/community/CommunityEditModeratorsRules.sol:CommunityEditModeratorsRules", ruleList.COMMUNITY_EDIT_MODERATOR_RULES());
}

async function setupRule(_registryContract, _rule, pathName, _ruleName) {
    const rulesFactory =  await ethers.getContractFactory(pathName);
    const rulesContract = await rulesFactory.deploy(_registryContract.address);
    await _rule.setRuleContract(_ruleName, version, rulesContract.address);
}
