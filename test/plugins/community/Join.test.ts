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
    let pluginName, version;
    let registry, executor, communityData;
    let createdCommunity;

    before(async function () {
        ({
            owner, creator, third,
            pluginName, version,
            registry, executor, communityData,
            createdCommunity
        } = await setupContracts());
    })

    it("Should check owner", async function () {
        console.log("owner = ", owner.address)
    });


});