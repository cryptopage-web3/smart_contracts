/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PageToken, PageTokenInterface } from "../PageToken";

const _abi = [
    {
        inputs: [
            {
                internalType: "address",
                name: "_PAGE_MINTER",
                type: "address",
            },
        ],
        stateMutability: "nonpayable",
        type: "constructor",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "owner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "Approval",
        type: "event",
    },
    {
        anonymous: false,
        inputs: [
            {
                indexed: true,
                internalType: "address",
                name: "from",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                indexed: false,
                internalType: "uint256",
                name: "value",
                type: "uint256",
            },
        ],
        name: "Transfer",
        type: "event",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "owner",
                type: "address",
            },
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
        ],
        name: "allowance",
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
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "approve",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
        ],
        name: "balanceOf",
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
        name: "decimals",
        outputs: [
            {
                internalType: "uint8",
                name: "",
                type: "uint8",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "subtractedValue",
                type: "uint256",
            },
        ],
        name: "decreaseAllowance",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "spender",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "addedValue",
                type: "uint256",
            },
        ],
        name: "increaseAllowance",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "account",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "isEnoughOn",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "mint",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "name",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
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
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "safeDeposit",
        outputs: [],
        stateMutability: "nonpayable",
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
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "safeWithdraw",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "symbol",
        outputs: [
            {
                internalType: "string",
                name: "",
                type: "string",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "totalSupply",
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
                internalType: "address",
                name: "recipient",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "transfer",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "sender",
                type: "address",
            },
            {
                internalType: "address",
                name: "recipient",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "amount",
                type: "uint256",
            },
        ],
        name: "transferFrom",
        outputs: [
            {
                internalType: "bool",
                name: "",
                type: "bool",
            },
        ],
        stateMutability: "nonpayable",
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
        name: "xburn",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

const _bytecode =
    "0x60806040523480156200001157600080fd5b5060405162000fbd38038062000fbd833981016040819052620000349162000169565b604080518082018252600b81526a43727970746f205061676560a81b6020808301918252835180850190945260048452635041474560e01b9084015281519192916200008391600391620000c3565b50805162000099906004906020840190620000c3565b5050600580546001600160a01b0319166001600160a01b03939093169290921790915550620001d6565b828054620000d19062000199565b90600052602060002090601f016020900481019282620000f5576000855562000140565b82601f106200011057805160ff191683800117855562000140565b8280016001018555821562000140579182015b828111156200014057825182559160200191906001019062000123565b506200014e92915062000152565b5090565b5b808211156200014e576000815560010162000153565b6000602082840312156200017b578081fd5b81516001600160a01b038116811462000192578182fd5b9392505050565b600181811c90821680620001ae57607f821691505b60208210811415620001d057634e487b7160e01b600052602260045260246000fd5b50919050565b610dd780620001e66000396000f3fe608060405234801561001057600080fd5b506004361061010b5760003560e01c806342966c68116100a2578063a457c2d711610071578063a457c2d714610217578063a504a5661461022a578063a9059cbb1461023d578063dd62ed3e14610250578063f49f5891146101fc57600080fd5b806342966c68146101c057806370a08231146101d35780637a0847a8146101fc57806395d89b411461020f57600080fd5b806323b872dd116100de57806323b872dd14610178578063313ce5671461018b578063395093511461019a57806340c10f19146101ad57600080fd5b8063040d976b1461011057806306fdde0314610125578063095ea7b31461014357806318160ddd14610166575b600080fd5b61012361011e366004610c2b565b610289565b005b61012d6102ca565b60405161013a9190610c8c565b60405180910390f35b610156610151366004610c2b565b61035c565b604051901515815260200161013a565b6002545b60405190815260200161013a565b610156610186366004610bf0565b610373565b6040516012815260200161013a565b6101566101a8366004610c2b565b61041d565b6101236101bb366004610c2b565b610459565b6101236101ce366004610c74565b61048d565b61016a6101e1366004610b9d565b6001600160a01b031660009081526020819052604090205490565b61012361020a366004610bf0565b61049a565b61012d61057d565b610156610225366004610c2b565b61058c565b610156610238366004610c2b565b610625565b61015661024b366004610c2b565b610654565b61016a61025e366004610bbe565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205490565b6005546001600160a01b031633146102bc5760405162461bcd60e51b81526004016102b390610cdf565b60405180910390fd5b6102c68282610661565b5050565b6060600380546102d990610d50565b80601f016020809104026020016040519081016040528092919081815260200182805461030590610d50565b80156103525780601f1061032757610100808354040283529160200191610352565b820191906000526020600020905b81548152906001019060200180831161033557829003601f168201915b5050505050905090565b60006103693384846107af565b5060015b92915050565b60006103808484846108d3565b6001600160a01b0384166000908152600160209081526040808320338452909152902054828110156104055760405162461bcd60e51b815260206004820152602860248201527f45524332303a207472616e7366657220616d6f756e74206578636565647320616044820152676c6c6f77616e636560c01b60648201526084016102b3565b61041285338584036107af565b506001949350505050565b3360008181526001602090815260408083206001600160a01b03871684529091528120549091610369918590610454908690610d21565b6107af565b6005546001600160a01b031633146104835760405162461bcd60e51b81526004016102b390610cdf565b6102c68282610aa2565b6104973382610661565b50565b600554604051631da68a2b60e21b81523360048201526001600160a01b039091169063769a28ac9060240160206040518083038186803b1580156104dd57600080fd5b505afa1580156104f1573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906105159190610c54565b61056d5760405162461bcd60e51b8152602060048201526024808201527f6f6e6c79536166653a2063616c6c6572206973206e6f7420696e2073616665206044820152631b1a5cdd60e21b60648201526084016102b3565b6105788383836108d3565b505050565b6060600480546102d990610d50565b3360009081526001602090815260408083206001600160a01b03861684529091528120548281101561060e5760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f77604482015264207a65726f60d81b60648201526084016102b3565b61061b33858584036107af565b5060019392505050565b6001600160a01b038216600090815260208190526040812054821161064c5750600161036d565b50600061036d565b60006103693384846108d3565b6001600160a01b0382166106c15760405162461bcd60e51b815260206004820152602160248201527f45524332303a206275726e2066726f6d20746865207a65726f206164647265736044820152607360f81b60648201526084016102b3565b6001600160a01b038216600090815260208190526040902054818110156107355760405162461bcd60e51b815260206004820152602260248201527f45524332303a206275726e20616d6f756e7420657863656564732062616c616e604482015261636560f01b60648201526084016102b3565b6001600160a01b0383166000908152602081905260408120838303905560028054849290610764908490610d39565b90915550506040518281526000906001600160a01b038516907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9060200160405180910390a3505050565b6001600160a01b0383166108115760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f206164646044820152637265737360e01b60648201526084016102b3565b6001600160a01b0382166108725760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f206164647265604482015261737360f01b60648201526084016102b3565b6001600160a01b0383811660008181526001602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925910160405180910390a3505050565b6001600160a01b0383166109375760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f206164604482015264647265737360d81b60648201526084016102b3565b6001600160a01b0382166109995760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201526265737360e81b60648201526084016102b3565b6001600160a01b03831660009081526020819052604090205481811015610a115760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e7420657863656564732062604482015265616c616e636560d01b60648201526084016102b3565b6001600160a01b03808516600090815260208190526040808220858503905591851681529081208054849290610a48908490610d21565b92505081905550826001600160a01b0316846001600160a01b03167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef84604051610a9491815260200190565b60405180910390a350505050565b6001600160a01b038216610af85760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f20616464726573730060448201526064016102b3565b8060026000828254610b0a9190610d21565b90915550506001600160a01b03821660009081526020819052604081208054839290610b37908490610d21565b90915550506040518181526001600160a01b038316906000907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef9060200160405180910390a35050565b80356001600160a01b0381168114610b9857600080fd5b919050565b600060208284031215610bae578081fd5b610bb782610b81565b9392505050565b60008060408385031215610bd0578081fd5b610bd983610b81565b9150610be760208401610b81565b90509250929050565b600080600060608486031215610c04578081fd5b610c0d84610b81565b9250610c1b60208501610b81565b9150604084013590509250925092565b60008060408385031215610c3d578182fd5b610c4683610b81565b946020939093013593505050565b600060208284031215610c65578081fd5b81518015158114610bb7578182fd5b600060208284031215610c85578081fd5b5035919050565b6000602080835283518082850152825b81811015610cb857858101830151858201604001528201610c9c565b81811115610cc95783604083870101525b50601f01601f1916929092016040019392505050565b60208082526022908201527f6f6e6c7941646d696e3a2063616c6c6572206973206e6f74207468652061646d60408201526134b760f11b606082015260800190565b60008219821115610d3457610d34610d8b565b500190565b600082821015610d4b57610d4b610d8b565b500390565b600181811c90821680610d6457607f821691505b60208210811415610d8557634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052601160045260246000fdfea2646970667358221220e7f67f2f18d7d7bb7b5d95f7939cb3d18b950e90e1f99642af6f2f4018bed3b364736f6c63430008040033";

type PageTokenConstructorParams =
    | [signer?: Signer]
    | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
    xs: PageTokenConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class PageToken__factory extends ContractFactory {
    constructor(...args: PageTokenConstructorParams) {
        if (isSuperArgs(args)) {
            super(...args);
        } else {
            super(_abi, _bytecode, args[0]);
        }
    }

    deploy(
        _PAGE_MINTER: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PageToken> {
        return super.deploy(
            _PAGE_MINTER,
            overrides || {}
        ) as Promise<PageToken>;
    }
    getDeployTransaction(
        _PAGE_MINTER: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): TransactionRequest {
        return super.getDeployTransaction(_PAGE_MINTER, overrides || {});
    }
    attach(address: string): PageToken {
        return super.attach(address) as PageToken;
    }
    connect(signer: Signer): PageToken__factory {
        return super.connect(signer) as PageToken__factory;
    }
    static readonly bytecode = _bytecode;
    static readonly abi = _abi;
    static createInterface(): PageTokenInterface {
        return new utils.Interface(_abi) as PageTokenInterface;
    }
    static connect(
        address: string,
        signerOrProvider: Signer | Provider
    ): PageToken {
        return new Contract(address, _abi, signerOrProvider) as PageToken;
    }
}