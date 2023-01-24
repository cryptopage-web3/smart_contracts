import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;

let communityCreatePluginName = keccak256(defaultAbiCoder.encode(["string"],
        ["COMMUNITY_CREATE"])
);
let communityJoinPluginName = keccak256(defaultAbiCoder.encode(["string"],
        ["COMMUNITY_JOIN"])
);
let communityQuitPluginName = keccak256(defaultAbiCoder.encode(["string"],
    ["COMMUNITY_QUIT"])
);
let writePostPluginName = keccak256(defaultAbiCoder.encode(["string"],
    ["COMMUNITY_WRITE_POST"])
);
let readPostPluginName = keccak256(defaultAbiCoder.encode(["string"],
    ["COMMUNITY_READ_POST"])
);

let version = 1;


export default async function setupContracts() {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;

    let registry, executor;
    let contractBlank;

    let bank, token, nft, soulBound, rule;
    let dao = AddressZero;
    let treasury;
    let communityData, postData, commentData;

    let firstCommunityName = "First community";

    [owner, creator, third] = await getSigners();

    const registryFactory = await ethers.getContractFactory("contracts/registry/Registry.sol:Registry");
    registry = await registryFactory.deploy();
    await registry.deployed();
    treasury = registry.address;
    await registry.initialize(dao, treasury);

    const accountFactory = await ethers.getContractFactory("contracts/account/Account.sol:Account");
    let account = await accountFactory.deploy();
    await account.initialize(registry.address);
    await registry.setAccount(account.address);

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

    const nftFactory = await ethers.getContractFactory("contracts/tokens/nft/NFT.sol:NFT");
    nft = await nftFactory.deploy();
    await nft.initialize(registry.address, 8, "https://nft.page");
    await registry.setNFT(nft.address);

    const bankFactory = await ethers.getContractFactory("contracts/bank/Bank.sol:Bank");
    bank = await bankFactory.deploy();
    await bank.initialize(registry.address);
    await registry.setBank(bank.address);

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

    await setupCommonPlugins(registry, version, owner);
    await setupCommonRules(registry,version, rule);

    let id = ethers.utils.formatBytes32String("1");
    let data = defaultAbiCoder.encode([ "string", "bool" ], [firstCommunityName, true ]);

    await executor.run(id, communityCreatePluginName, version, data);

    let afterCount = await communityData.communitiesCount();
    let index = afterCount.sub(BigNumber.from(1));
    let createdCommunityAddress = await communityData.getCommunities(index, index);

    let communityBlank = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
    let createdCommunity = await communityBlank.attach(createdCommunityAddress[0]);

    return {
        owner, creator, third,
        version,
        registry, executor,
        communityData, postData, commentData,
        createdCommunity, account
    };
}

async function setupCommonPlugins(_registryContract, version, user) {

    let pluginFactory = await ethers.getContractFactory("contracts/plugins/community/Create.sol:Create");
    let communityCreatePlugin = await pluginFactory.deploy(_registryContract.address, user.address);
    await communityCreatePlugin.deployed();
    await _registryContract.setPlugin(communityCreatePluginName, version, communityCreatePlugin.address);

    await setupPlugin(_registryContract, version, "contracts/plugins/community/Join.sol:Join", communityJoinPluginName);
    await setupPlugin(_registryContract, version, "contracts/plugins/community/Quit.sol:Quit", communityQuitPluginName);

    await setupPlugin(_registryContract, version, "contracts/plugins/post/Write.sol:Write", writePostPluginName);
    await setupPlugin(_registryContract, version, "contracts/plugins/post/Read.sol:Read", readPostPluginName);
}

async function setupPlugin(_registryContract, version, pathName, pluginName) {
    let pluginFactory = await ethers.getContractFactory(pathName);
    let pluginContract = await pluginFactory.deploy(_registryContract.address);
    await pluginContract.deployed();
    await _registryContract.setPlugin(pluginName, version, pluginContract.address);
}

async function setupCommonRules(_registryContract, _version, _ruleContract) {
    let communityJoiningRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.COMMUNITY_JOINING_RULES"])
    );
    let userVerificationRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.USER_VERIFICATION_RULES"])
    );
    let editModeratorRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.COMMUNITY_EDIT_MODERATOR_RULES"])
    );
    let postPlacingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.POST_PLACING_RULES"])
    );
    let postAcceptingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.ACCEPTING_POST_RULES"])
    );
    let postReadingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.POST_READING_RULES"])
    );
    let postCommentingRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.POST_COMMENTING_RULES"])
    );
    let changeVisibilityRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.CHANGE_VISIBILITY_CONTENT_RULES"])
    );
    let moderationRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.MODERATION_RULES"])
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
    let postTransferringRulesName = keccak256(defaultAbiCoder.encode(["string"],
        ["PAGE.POST_TRANSFERRING_RULES"])
    );

    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/CommunityJoiningRules.sol:CommunityJoiningRules", communityJoiningRulesName);
    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/UserVerificationRules.sol:UserVerificationRules", userVerificationRulesName);

    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/PostCommentingRules.sol:PostCommentingRules", postCommentingRulesName);
    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/PostPlacingRules.sol:PostPlacingRules", postPlacingRulesName);
    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/PostReadingRules.sol:PostReadingRules", postReadingRulesName);
    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/PostTransferringRules.sol:PostTransferringRules", postTransferringRulesName);
}

async function setupRule(_registryContract, _rule, _version, pathName, _ruleName) {
    const rulesFactory =  await ethers.getContractFactory(pathName);
    const rulesContract = await rulesFactory.deploy(_registryContract.address);
    await _rule.setRuleContract(_ruleName, _version, rulesContract.address);
}
