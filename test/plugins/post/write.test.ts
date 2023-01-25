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

        let postNftAddress = await postData.nft();
        let regNftAddress = await registry.nft();
        expect(postNftAddress).to.equal(
            regNftAddress
        );

        data = defaultAbiCoder.encode(
            [ "address", "address", "string", "uint256", "string[]", "bool", "bool" ],
            [communityAddress, third.address, "#1 hash for post", 0, ["1", "2"], false, true]
        );
        id = ethers.utils.formatBytes32String("11");
        await executor.connect(third).run(id, pluginList.COMMUNITY_WRITE_POST(), version, data);

        let afterBalance = await nft.balanceOf(third.address);
        expect(afterBalance).to.equal(
            BigNumber.from(1)
        );

        let postIds = await account.getPostIdsByUserAndCommunity(communityAddress, third.address);

        let postId = postIds[0].toNumber();
        console.log("postId = ", postId);

        data = defaultAbiCoder.encode(
            [ "uint256" ],
            [ postId ]
        );

        let readInfo = await executor.connect(third).read(pluginList.COMMUNITY_READ_POST(), version, data);
        console.log("readInfo = ", readInfo);

        //0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000400000000000000000000000009467a509da43cb50eb332187602534991be1fea40000000000000000000000000000000000000000000000000000000000000001
        //0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000010000000000000000000000009467a509da43cb50eb332187602534991be1fea4
        data = defaultAbiCoder.decode(
            // [ "uint256", "uint256", "uint256", "address", "bytes" ],
            [ "uint256", "uint256", "uint256", "address" ],
            readInfo
        );

        // let postInfo = defaultAbiCoder.decode(
        //     // [ "string", "string", "string[]", "address", "address", "uint256", "uint256", "uint256", "uint256", "uint256", "address[]" ],
        //     [ "string", "string", "string[]", "address", "address" ],
        //     data[4]
        // );

        console.log("postInfo = ", data);

    });


});