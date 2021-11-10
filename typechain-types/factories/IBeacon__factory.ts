/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { IBeacon, IBeaconInterface } from "../IBeacon";

const _abi = [
    {
        inputs: [],
        name: "childImplementation",
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
                internalType: "address",
                name: "newImplementation",
                type: "address",
            },
        ],
        name: "upgradeChildTo",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

export class IBeacon__factory {
    static readonly abi = _abi;
    static createInterface(): IBeaconInterface {
        return new utils.Interface(_abi) as IBeaconInterface;
    }
    static connect(
        address: string,
        signerOrProvider: Signer | Provider
    ): IBeacon {
        return new Contract(address, _abi, signerOrProvider) as IBeacon;
    }
}
