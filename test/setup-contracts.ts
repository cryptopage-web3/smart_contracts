import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;

export default async function setupContracts() {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;

    let communityCreatePlugin, communityJoinPlugin;
    let registry, executor;
    let contractBlank;

    let bank = AddressZero;
    let token;
    let dao = AddressZero;
    let treasury;
    let rule;
    let communityData;

    let communityJoiningRules

    let firstCommunityName = "First community";

    let communityCreatePluginName = keccak256(defaultAbiCoder.encode(
            ["string"],
            ["COMMUNITY_CREATE"]
        )
    );
    let communityJoinPluginName = keccak256(defaultAbiCoder.encode(
            ["string"],
            ["COMMUNITY_JOIN"]
        )
    );

    let communityJoiningRulesName = keccak256(defaultAbiCoder.encode(
            ["string"],
            ["PAGE.COMMUNITY_JOINING_RULES"]
        )
    );

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

    await registry.setSoulBound(communityData.address);

    const blankFactory = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
    contractBlank = await blankFactory.deploy();

    const communityCreatePluginFactory = await ethers.getContractFactory("contracts/plugins/community/Create.sol:Create");
    communityCreatePlugin = await communityCreatePluginFactory.deploy(registry.address, owner.address);
    await communityCreatePlugin.deployed();
    await registry.setPlugin(communityCreatePluginName, version, communityCreatePlugin.address);

    const communityJoinPluginFactory = await ethers.getContractFactory("contracts/plugins/community/Join.sol:Join");
    communityJoinPlugin = await communityJoinPluginFactory.deploy(registry.address);
    await communityJoinPlugin.deployed();
    await registry.setPlugin(communityJoinPluginName, version, communityJoinPlugin.address);

    const ruleFactory = await ethers.getContractFactory("contracts/rules/Rule.sol:Rule");
    rule = await ruleFactory.deploy();
    await rule.initialize();
    await registry.setRule(rule.address);

    const communityJoiningRulesFactory =  await ethers.getContractFactory("contracts/rules/community/CommunityJoiningRules.sol:CommunityJoiningRules");
    communityJoiningRules = await communityJoiningRulesFactory.deploy(registry.address);
    await rule.setRuleContract(communityJoiningRulesName, version, communityJoiningRules.address);

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
