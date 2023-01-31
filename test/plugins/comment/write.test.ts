import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Write comment basic functionality", function () {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;
    let version, ruleList, pluginList;
    let registry, executor, bank, communityData, postData, commentData;
    let createdCommunity, account;
    let token, nft, soulBound;

    before(async function () {
        ({
            owner, creator, third,
            version, ruleList, pluginList,
            registry, executor,bank,
            token, nft, soulBound,
            communityData, postData, commentData, account,
            createdCommunity
        } = await setupContracts());

    })

    it("Should write/read comment", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("20");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        id = ethers.utils.formatBytes32String("21");
        await executor.connect(creator).run(id, pluginList.COMMUNITY_JOIN(), version, data);

        let postHash = "#1 hash for post";
        let tags = ["1", "2"];

        data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, postHash, 0, tags, false, true]
        );

        id = ethers.utils.formatBytes32String("22");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);
        let postId = postIds[0].toNumber();

        let commentHash1 = "#1 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, third.address, commentHash1, true, false, false, true]
        );
        id = ethers.utils.formatBytes32String("23");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_COMMENT(), version, data);

        let commentHash2 = "#2 hash for comment";
        data = defaultAbiCoder.encode(
            [ "address", "uint256", "address", "string", "bool", "bool", "bool", "bool" ],
            [communityAddress, postId, creator.address, commentHash2, false, true, false, true]
        );
        id = ethers.utils.formatBytes32String("24");
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
    });


});