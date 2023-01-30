import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Write post basic functionality", function () {

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

    it("Should write post", async function () {
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
        expect(third.address).to.equal(readInfo.owner);
        expect(postHash).to.equal(readInfo.postData.ipfsHash);
        expect(tags[0]).to.equal(readInfo.postData.tags[0]);

    });


});