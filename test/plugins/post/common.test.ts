import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Post basic functionality", function () {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;
    let version, ruleList, pluginList;
    let registry, rule, executor, bank, communityData, postData, commentData;
    let createdCommunity, account;
    let token, nft, soulBound;

    before(async function () {
        ({
            owner, creator, third,
            version, ruleList, pluginList,
            registry, rule, executor,bank,
            token, nft, soulBound,
            communityData, postData, commentData, account,
            createdCommunity
        } = await setupContracts());

    })

    it("Should write/read post", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("10");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        let beforeBalance = await nft.balanceOf(third.address);
        expect(beforeBalance).to.equal(
            BigNumber.from(0)
        );

        let postNftAddress = await postData.nft();
        let regNftAddress = await registry.nft();
        expect(postNftAddress).to.equal(
            regNftAddress
        );

        let postHash = "#1 hash for post";
        let tags = ["1", "2"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );
        id = ethers.utils.formatBytes32String("11");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let afterBalance = await nft.balanceOf(third.address);
        expect(afterBalance).to.equal(
            BigNumber.from(1)
        );

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);

        let readInfo = await plugin.connect(third).read(postId);

        expect(communityAddress).to.equal(readInfo.communityId);
        expect(third.address).to.equal(readInfo.currentOwner);
        expect(postHash).to.equal(readInfo.ipfsHash);
        expect(tags[0]).to.equal(readInfo.tags[0]);

    });

    it("Should burn post", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("12");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(creator).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        let beforeBalance = await nft.balanceOf(third.address);
        expect(beforeBalance).to.equal(
            BigNumber.from(1)
        );

        let postNftAddress = await postData.nft();
        let regNftAddress = await registry.nft();
        expect(postNftAddress).to.equal(
            regNftAddress
        );

        let postHash = "#2 hash for post";
        let tags = ["3", "4"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );
        id = ethers.utils.formatBytes32String("13");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let afterBalance = await nft.balanceOf(third.address);
        expect(afterBalance).to.equal(
            BigNumber.from(2)
        );

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        data = defaultAbiCoder.encode(
            [ "address", "address", "bool" ],
            [communityAddress, creator.address, true]
        );
        id = ethers.utils.formatBytes32String("14");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_EDIT_MODERATORS(), version, data);

        await rule.connect(owner).enableRule(ruleList.MODERATION_RULES(), version, ruleList.MODERATION_USING_MODERATORS());
        await createdCommunity.connect(owner).linkRule(ruleList.MODERATION_RULES(), version, ruleList.MODERATION_USING_MODERATORS());

        data = defaultAbiCoder.encode(
            [ "uint256" ],
            [postId]
        );
        id = ethers.utils.formatBytes32String("15");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_BURN_POST(), version, data);

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);
        let readInfo = await plugin.connect(third).read(postId);

        expect(false).to.equal(readInfo.isView);
    });

    it("Should change visibility post", async function () {
        let communityAddress = createdCommunity.address;

        let postHash = "#3 hash for post";
        let tags = ["5", "6"];

        let data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );
        let id = ethers.utils.formatBytes32String("16");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[2].toNumber();

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        let readPlugin = await pluginFactory.attach(pluginAddress);
        let readInfo = await readPlugin.connect(third).read(postId);
        expect(true).to.equal(readInfo.isView);

        let pathName = "contracts/plugins/post/ChangeVisibility.sol:ChangeVisibility";
        let pluginName = pluginList.COMMUNITY_CHANGE_VISIBILITY_POST();
        pluginFactory = await ethers.getContractFactory(pathName);
        let pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();
        await registry.setPlugin(pluginName, version, pluginContract.address);

        await createdCommunity.connect(owner).linkPlugin(pluginList.COMMUNITY_CHANGE_VISIBILITY_POST(), version);

        pathName = "contracts/rules/community/ChangeVisibilityContentRules.sol:ChangeVisibilityContentRules";
        let ruleName = keccak256(defaultAbiCoder.encode(["string"], ["PAGE.CHANGE_VISIBILITY_CONTENT_RULES"]));
        let rulesFactory =  await ethers.getContractFactory(pathName);
        let rulesContract = await rulesFactory.deploy(registry.address);
        await rule.setRuleContract(ruleName, version, rulesContract.address);

        await rule.connect(owner).enableRule(ruleList.CHANGE_VISIBILITY_CONTENT_RULES(), version, ruleList.CHANGE_VISIBILITY_ONLY_OWNER());
        await createdCommunity.connect(owner).linkRule(ruleList.CHANGE_VISIBILITY_CONTENT_RULES(), version, ruleList.CHANGE_VISIBILITY_ONLY_OWNER());

        data = defaultAbiCoder.encode(
            [ "uint256", "bool" ],
            [postId, false]
        );
        id = ethers.utils.formatBytes32String("17");
        await executor.connect(third).run(id, pluginList.COMMUNITY_CHANGE_VISIBILITY_POST(), version, data);

        readInfo = await readPlugin.connect(third).read(postId);
        expect(false).to.equal(readInfo.isView);

    });

    it("Should gas compensation post", async function () {
        let communityAddress = createdCommunity.address;

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        expect(3).to.equal(postIds.length);
        let postId0 = postIds[0].toNumber(); //"8000000000001"
        let postId1 = postIds[1].toNumber(); //"8000000000002"

        let pathName = "contracts/plugins/post/GasCompensation.sol:GasCompensation";
        let pluginName = pluginList.COMMUNITY_POST_GAS_COMPENSATION();
        let pluginFactory = await ethers.getContractFactory(pathName);
        let pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();

        await registry.setPlugin(pluginName, version, pluginContract.address);
        await createdCommunity.connect(owner).linkPlugin(pluginList.COMMUNITY_POST_GAS_COMPENSATION(), version);

        pathName = "contracts/plugins/bank/BalanceOf.sol:BalanceOf";
        pluginName = pluginList.BANK_BALANCE_OF();
        pluginFactory = await ethers.getContractFactory(pathName);
        pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();

        await registry.setPlugin(pluginName, version, pluginContract.address);
        await createdCommunity.connect(owner).linkPlugin(pluginList.BANK_BALANCE_OF(), version);

        pathName = "contracts/rules/community/GasCompensationRules.sol:GasCompensationRules";
        let ruleName = keccak256(defaultAbiCoder.encode(["string"], ["PAGE.GAS_COMPENSATION_RULES"]));
        let rulesFactory =  await ethers.getContractFactory(pathName);
        let rulesContract = await rulesFactory.deploy(registry.address);
        await rule.setRuleContract(ruleName, version, rulesContract.address);

        await rule.connect(owner).enableRule(ruleList.GAS_COMPENSATION_RULES(), version, ruleList.GAS_COMPENSATION_FOR_OWNER());
        await createdCommunity.connect(owner).linkRule(ruleList.GAS_COMPENSATION_RULES(), version, ruleList.GAS_COMPENSATION_FOR_OWNER());

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        let readPlugin = await pluginFactory.attach(pluginAddress);

        let readInfo = await readPlugin.connect(third).read(postId1);
        expect(false).to.equal(readInfo.isGasCompensation);

        pluginAddress = await registry.getPluginContract(pluginList.BANK_BALANCE_OF(), version);
        pluginFactory = await ethers.getContractFactory("contracts/plugins/bank/BalanceOf.sol:BalanceOf");
        let balancePlugin = await pluginFactory.attach(pluginAddress);
        let balanceOf = await balancePlugin.connect(third).read(third.address);

        let data = defaultAbiCoder.encode(
            [ "uint256[]" ],
            [ [postId1] ]
        );
        let id = ethers.utils.formatBytes32String("18");

        let tx = await executor.connect(third).run(id, pluginList.COMMUNITY_POST_GAS_COMPENSATION(), version, data);

        readInfo = await readPlugin.connect(third).read(postId1);
        expect(true).to.equal(readInfo.isView);

        balanceOf = await balancePlugin.connect(third).read(third.address);
        expect(balanceOf > 0).to.be.true;

    });
});