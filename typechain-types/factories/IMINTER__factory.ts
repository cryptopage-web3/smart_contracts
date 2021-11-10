/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IMINTER, IMINTERInterface } from "../IMINTER";

const _abi = [
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "uint256",
                name: "_addressCount",
                type: "uint256",
            },
        ],
        name: "amountMint",
        outputs: [
            {
                internalType: "uint256",
                name: "amountEach",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "fee",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "burn",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "getAdmin",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getBurnNFT",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
        ],
        name: "getMinter",
        outputs: [
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                internalType: "address",
                name: "author",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
            {
                internalType: "bool",
                name: "xmint",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "getPageToken",
        outputs: [
            {
                internalType: "address",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address[]",
                name: "_to",
                type: "address[]",
            },
        ],
        name: "mint",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address",
                name: "_to",
                type: "address",
            },
        ],
        name: "mint1",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address",
                name: "_to1",
                type: "address",
            },
            {
                internalType: "address",
                name: "_to2",
                type: "address",
            },
        ],
        name: "mint2",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address",
                name: "_to1",
                type: "address",
            },
            {
                internalType: "address",
                name: "_to2",
                type: "address",
            },
            {
                internalType: "address",
                name: "_to3",
                type: "address",
            },
        ],
        name: "mint3",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address[]",
                name: "_to",
                type: "address[]",
            },
            {
                internalType: "uint256",
                name: "_multiplier",
                type: "uint256",
            },
        ],
        name: "mintX",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
        ],
        name: "removeMinter",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_cost",
                type: "uint256",
            },
        ],
        name: "setBurnNFT",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_key",
                type: "string",
            },
            {
                internalType: "address",
                name: "_account",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "_pageamount",
                type: "uint256",
            },
            {
                internalType: "bool",
                name: "_xmint",
                type: "bool",
            },
        ],
        name: "setMinter",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

export class IMINTER__factory {
    static readonly abi = _abi;
    static createInterface(): IMINTERInterface {
        return new utils.Interface(_abi) as IMINTERInterface;
    }
    static connect(
        address: string,
        signerOrProvider: Signer | Provider
    ): IMINTER {
        return new Contract(address, _abi, signerOrProvider) as IMINTER;
    }
}
