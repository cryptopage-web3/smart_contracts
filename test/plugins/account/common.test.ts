import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Account basic functionality", function () {

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

    it("Should write/read account info by community", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("30");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        id = ethers.utils.formatBytes32String("31");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        let postHash = "#1 hash for post";
        let tags = ["1", "2"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, AddressZero, third.address, postHash, 0, tags, false, true]
        );

        id = ethers.utils.formatBytes32String("32");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[1][0].toNumber();

        let commentHash1 = "#1 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, third.address, commentHash1, true, false, false, true]
        );
        id = ethers.utils.formatBytes32String("33");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let commentHash2 = "#2 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, creator.address, commentHash2, false, true, false, true]
        );
        id = ethers.utils.formatBytes32String("34");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_COMMENT(), version);
        let pluginFactory = await ethers.getContractFactory("contracts/plugins/comment/Read.sol:Read");
        let plugin = await pluginFactory.attach(pluginAddress);

        let commentInfo = await plugin.connect(third).read(postId, 1);
        expect(communityAddress).to.equal(commentInfo.communityId);
        expect(third.address).to.equal(commentInfo.owner);
        expect(commentHash1).to.equal(commentInfo.ipfsHash);

        commentInfo = await plugin.connect(third).read(postId, 2);
        expect(communityAddress).to.equal(commentInfo.communityId);
        expect(creator.address).to.equal(commentInfo.owner);
        expect(commentHash2).to.equal(commentInfo.ipfsHash);

        pluginAddress = await registry.getPluginContract(pluginList.COMMUNITY_READ_POST(), version);
        pluginFactory = await ethers.getContractFactory("contracts/plugins/post/Read.sol:Read");
        plugin = await pluginFactory.attach(pluginAddress);

        let pathName = "contracts/plugins/user/InfoByCommunity.sol:InfoByCommunity";
        let pluginName = pluginList.USER_INFO_ONE_COMMUNITY();
        pluginFactory = await ethers.getContractFactory(pathName);
        let pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();
        await registry.setPlugin(pluginName, version, pluginContract.address);


        let userRate = await pluginContract.read(third.address, communityAddress);
        expect(userRate.postCount.toNumber()).to.equal(1);
        expect(userRate.commentCount.toNumber()).to.equal(1);
        expect(userRate.upCount.toNumber()).to.equal(1);
        expect(userRate.downCount.toNumber()).to.equal(0);

        userRate = await pluginContract.read(creator.address, communityAddress);
        expect(userRate.postCount.toNumber()).to.equal(0);
        expect(userRate.commentCount.toNumber()).to.equal(1);
        expect(userRate.upCount.toNumber()).to.equal(0);
        expect(userRate.downCount.toNumber()).to.equal(1);

        let communities = await communityData.getCommunities(0, 1);
        let secondCommunityAddress = communities[1];
        let communityJoinPluginName = keccak256(defaultAbiCoder.encode(["string"],
            ["COMMUNITY_JOIN"])
        );

        id = ethers.utils.formatBytes32String("35");
        data = defaultAbiCoder.encode([ "address" ], [secondCommunityAddress]);
        await executor.connect(third).run(id, communityJoinPluginName, version, data);


        postHash = "#3 hash for new post";
        tags = ["00", "01"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [secondCommunityAddress, AddressZero, third.address, postHash, 0, tags, false, true]
        );
        id = ethers.utils.formatBytes32String("36");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        pathName = "contracts/plugins/user/InfoAllCommunities.sol:InfoAllCommunities";
        pluginName = pluginList.USER_INFO_ALL_COMMUNITIES();
        pluginFactory = await ethers.getContractFactory(pathName);
        pluginContract = await pluginFactory.deploy(registry.address);
        await pluginContract.deployed();
        await registry.setPlugin(pluginName, version, pluginContract.address);

        userRate = await pluginContract.read(third.address);
        expect(userRate.postCount.toNumber()).to.equal(2);
        expect(userRate.commentCount.toNumber()).to.equal(1);
        expect(userRate.upCount.toNumber()).to.equal(1);
        expect(userRate.downCount.toNumber()).to.equal(0);
    });

});