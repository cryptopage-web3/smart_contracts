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
    let communityCreatePluginName, communityJoinPluginName, version;
    let registry, executor, communityData;
    let createdCommunity, account;

    before(async function () {
        ({
            owner, creator, third,
            communityCreatePluginName, communityJoinPluginName, version,
            registry, executor, communityData,
            createdCommunity, account
        } = await setupContracts());

    })

    it("Should join user", async function () {
        let communityAddress = createdCommunity.address;

        let beforeCounts = await account.getCommunityCounts(communityAddress);
        expect(beforeCounts.normalUsers).to.equal(
            BigNumber.from(0)
        );

        let id = ethers.utils.formatBytes32String("2");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, communityJoinPluginName, version, data);

        let afterCounts = await account.getCommunityCounts(communityAddress);
        expect(afterCounts.normalUsers).to.equal(
            BigNumber.from(1)
        );
    });


});