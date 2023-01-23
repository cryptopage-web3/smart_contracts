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


export default async function setupContracts() {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;

    let communityCreatePlugin, communityJoinPlugin;
    let registry, executor;
    let contractBlank;

    let bank, token, soulBound, rule;
    let dao = AddressZero;
    let treasury;
    let communityData;

    let communityJoiningRules

    let firstCommunityName = "First community";

    let version = 1;

    [owner, creator, third] = await getSigners();

    const registryFactory = await ethers.getContractFactory("contracts/registry/Registry.sol:Registry");
    registry = await registryFactory.deploy();
    await registry.deployed();
    treasury = registry.address;
    await registry.initialize(dao, treasury);

    const executorFactory = await ethers.getContractFactory("contracts/executor/Executor.sol:Executor");
    executor = await executorFactory.deploy();
    await executor.initialize(registry.address);
    await registry.setExecutor(executor.address);

    const communityDataFactory = await ethers.getContractFactory("contracts/community/CommunityData.sol:CommunityData");
    communityData = await communityDataFactory.deploy();
    await communityData.initialize(registry.address);
    await registry.setCommunityData(communityData.address);

    const tokenFactory = await ethers.getContractFactory("contracts/tokens/token/Token.sol:Token");
    token = await tokenFactory.deploy();
    await token.initialize(registry.address);
    await registry.setToken(token.address);

    const bankFactory = await ethers.getContractFactory("contracts/bank/Bank.sol:Bank");
    bank = await bankFactory.deploy();
    await bank.initialize(registry.address);
    await registry.setToken(bank.address);

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

    const accountFactory = await ethers.getContractFactory("contracts/account/Account.sol:Account");
    let account = await accountFactory.deploy();
    await account.initialize(registry.address);
    await registry.setAccount(account.address);

    return {
        owner, creator, third,
        communityCreatePluginName, communityJoinPluginName, version,
        registry, executor, communityData,
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

    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/CommunityJoiningRules.sol:CommunityJoiningRules", communityJoiningRulesName);
    await setupRule(_registryContract, _ruleContract, _version, "contracts/rules/community/UserVerificationRules.sol:UserVerificationRules", userVerificationRulesName);

}

async function setupRule(_registryContract, _rule, _version, pathName, _ruleName) {
    const rulesFactory =  await ethers.getContractFactory(pathName);
    const rulesContract = await rulesFactory.deploy(_registryContract.address);
    await _rule.setRuleContract(_ruleName, _version, rulesContract.address);
}
