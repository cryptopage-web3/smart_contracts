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

    let pluginCreate, registry, executor;
    let contractBlank;

    let bank = AddressZero;
    let token = AddressZero;
    let dao = AddressZero;
    let treasury = AddressZero;
    let rule = AddressZero;
    let communityData;

    let firstCommunityName = "First community";

    let pluginName = keccak256(defaultAbiCoder.encode(
            ["string"],
            ["COMMUNITY_CREATE"]
        )
    );
    let version = 1;

    [owner, creator, third] = await getSigners();

    const registryFactory = await ethers.getContractFactory("contracts/registry/Registry.sol:Registry");
    registry = await registryFactory.deploy();
    await registry.deployed();
    await registry.initialize(bank, token, dao, treasury, rule);

    const executorFactory = await ethers.getContractFactory("contracts/executor/Executor.sol:Executor");
    executor = await executorFactory.deploy();
    await executor.initialize(registry.address);
    await registry.setExecutor(executor.address);

    const communityDataFactory = await ethers.getContractFactory("contracts/community/CommunityData.sol:CommunityData");
    communityData = await communityDataFactory.deploy();
    await communityData.initialize(registry.address);
    await registry.setCommunityData(communityData.address);

    const blankFactory = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
    contractBlank = await blankFactory.deploy();

    const createFactory = await ethers.getContractFactory("contracts/plugins/community/Create.sol:Create");
    pluginCreate = await createFactory.deploy(registry.address, owner.address);
    await pluginCreate.deployed();

    await registry.setPlugin(pluginName, version, pluginCreate.address);

    let id = ethers.utils.formatBytes32String("1");
    let data = defaultAbiCoder.encode([ "string", "bool" ], [firstCommunityName, true ]);

    await executor.run(id, pluginName, version, data);

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
        pluginName, version,
        registry, executor, communityData,
        createdCommunity, account
    };
}