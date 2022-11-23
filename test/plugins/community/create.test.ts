import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;


describe("Test Create basic functionality", function () {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;

    let pluginCreate, contractBlank, registry;
    let bank = AddressZero;
    let token = AddressZero;
    let dao = AddressZero;
    let treasury = AddressZero;
    let executor;
    let rule = AddressZero;
    let communityData;

    let firstCommunityName = "First community";

    let pluginName = keccak256(defaultAbiCoder.encode(
            ["string"],
            ["COMMUNITY_CREATE"]
        )
    );
    let version = 1;


    before(async function () {
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
    })

    it("Should set blank", async function () {
        const blankBefore = await pluginCreate.blank();
        expect(blankBefore).to.equal(AddressZero);

        await pluginCreate.setBlank(contractBlank.address);

        const blankAfter = await pluginCreate.blank();
        expect(blankAfter).to.equal(contractBlank.address);
    });

    it("Should create community", async function () {
        let beforeCount = await communityData.communitiesCount();

        //bytes32 _id, bytes32 _pluginName, uint256 _version, bytes calldata _data
        let id = ethers.utils.formatBytes32String("1");
        // let data = defaultAbiCoder.encode([ "uint", "string" ], [ 1234, "Hello World" ]);
        let data = defaultAbiCoder.encode([ "string", "bool" ], [firstCommunityName, true ]);

        await executor.run(id, pluginName, version, data);

        let afterCount = await communityData.communitiesCount();
        expect(afterCount.sub(beforeCount)).to.equal(
            BigNumber.from(1)
        );

        let index = afterCount.sub(BigNumber.from(1));
        let createdCommunityAddress = await communityData.getCommunities(index, index);

        let communityBlank = await ethers.getContractFactory("contracts/community/CommunityBlank.sol:CommunityBlank");
        let createdCommunity = await communityBlank.attach(createdCommunityAddress[0]);

        expect(await createdCommunity.name()).to.equal(firstCommunityName);

    });

});
