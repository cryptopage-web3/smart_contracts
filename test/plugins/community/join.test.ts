import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { deployments, ethers, network, run } from "hardhat";
import { defaultAbiCoder, keccak256, parseEther } from "ethers/lib/utils";

import { BigNumber } from "ethers";

import setupContracts from "../../setup-contracts";

const { getContract, getSigners, provider } = ethers;
const { AddressZero, HashZero } = ethers.constants;
const { parseUnits, randomBytes } = ethers.utils;

describe("Test Join to community basic functionality", function () {

    let owner: SignerWithAddress,
        creator: SignerWithAddress,
        third: SignerWithAddress;
    let version, ruleList, pluginList;
    let registry, rule, executor, bank, communityData, postData, commentData;
    let createdCommunity, account;
    let token, nft, soulBound;

    let communityJoinPluginName = keccak256(defaultAbiCoder.encode(["string"],
        ["COMMUNITY_JOIN"])
    );

    before(async function () {
        ({
            owner, creator, third,
            version, ruleList, pluginList,
            registry, rule, executor, bank,
            token, nft, soulBound,
            communityData, postData, commentData, account,
            createdCommunity
        } = await setupContracts());

    })

    it("Should join user", async function () {
        let communityAddress = createdCommunity.address;

        let beforeCounts = await account.getCommunityUsersCounts(communityAddress);
        expect(beforeCounts.normalUsers).to.equal(
            BigNumber.from(0)
        );

        let id = ethers.utils.formatBytes32String("2");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, communityJoinPluginName, version, data);

        let afterCounts = await account.getCommunityUsersCounts(communityAddress);
        expect(afterCounts.normalUsers).to.equal(
            BigNumber.from(1)
        );

        let isCommunityUser = await account.isCommunityUser(communityAddress, third.address);
        expect(isCommunityUser).to.equal(true);
    });


});