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

    it("Should write post", async function () {
        let communityAddress = createdCommunity.address;

        let id = ethers.utils.formatBytes32String("2");
        let data = defaultAbiCoder.encode([ "address" ], [communityAddress]);
        await executor.connect(third).run(id, communityJoinPluginName, version, data);

        id = ethers.utils.formatBytes32String("3");

    });


});