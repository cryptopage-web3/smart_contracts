/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PageMinterNFT, PageMinterNFTInterface } from "../PageMinterNFT";

const _abi = [
    {
        inputs: [
            {
                internalType: "address",
                name: "_PAGE_MINTER",
                type: "address",
            },
            {
                internalType: "address",
                name: "_PAGE_TOKEN",
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
                name: "approved",
                type: "address",
            },
            {
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
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
                name: "owner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                indexed: false,
                internalType: "bool",
                name: "approved",
                type: "bool",
            },
        ],
        name: "ApprovalForAll",
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
                indexed: true,
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "Transfer",
        type: "event",
    },
    {
        inputs: [],
        name: "PAGE_MINTER",
        outputs: [
            {
                internalType: "contract IMINTER",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "PAGE_TOKEN",
        outputs: [
            {
                internalType: "contract IERC20",
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
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "approve",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "owner",
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
                name: "_tokenId",
                type: "uint256",
            },
        ],
        name: "burn",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_tokenId",
                type: "uint256",
            },
            {
                internalType: "string",
                name: "_comment_text",
                type: "string",
            },
            {
                internalType: "bool",
                name: "_like",
                type: "bool",
            },
        ],
        name: "comment",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_tokenId",
                type: "uint256",
            },
        ],
        name: "commentActivate",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "creatorOf",
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
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "getApproved",
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
        name: "getBaseURL",
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
                name: "owner",
                type: "address",
            },
            {
                internalType: "address",
                name: "operator",
                type: "address",
            },
        ],
        name: "isApprovedForAll",
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
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "ownerOf",
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
                name: "_tokenURI",
                type: "string",
            },
            {
                internalType: "bool",
                name: "_comment",
                type: "bool",
            },
        ],
        name: "safeMint",
        outputs: [
            {
                internalType: "uint256",
                name: "",
                type: "uint256",
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
                internalType: "address",
                name: "to",
                type: "address",
            },
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "safeTransferFrom",
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
                name: "tokenId",
                type: "uint256",
            },
            {
                internalType: "bytes",
                name: "_data",
                type: "bytes",
            },
        ],
        name: "safeTransferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "operator",
                type: "address",
            },
            {
                internalType: "bool",
                name: "approved",
                type: "bool",
            },
        ],
        name: "setApprovalForAll",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "url",
                type: "string",
            },
        ],
        name: "setBaseURL",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "bytes4",
                name: "interfaceId",
                type: "bytes4",
            },
        ],
        name: "supportsInterface",
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
        inputs: [
            {
                internalType: "uint256",
                name: "_tokenId",
                type: "uint256",
            },
        ],
        name: "tokenComments",
        outputs: [
            {
                internalType: "uint256",
                name: "id",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "comments",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "likes",
                type: "uint256",
            },
            {
                internalType: "uint256",
                name: "dislakes",
                type: "uint256",
            },
            {
                internalType: "address",
                name: "_contract",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "tokenURI",
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
                name: "tokenId",
                type: "uint256",
            },
        ],
        name: "transferFrom",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

const _bytecode =
    "0x60c0604052601560808190527f68747470733a2f2f697066732e696f2f697066732f000000000000000000000060a090815262000040916007919062000124565b503480156200004e57600080fd5b5060405162002ffd38038062002ffd8339810160408190526200007191620001e7565b604080518082018252600f81526e10dc9e5c1d1bc8141859d948139195608a1b602080830191825283518085019094526008845267141051d14b53919560c21b908401528151919291620000c89160009162000124565b508051620000de90600190602084019062000124565b5050600a80546001600160a01b039485166001600160a01b03199182168117909255600b805482169092179091556009805493909416921691909117909155506200025b565b82805462000132906200021e565b90600052602060002090601f016020900481019282620001565760008555620001a1565b82601f106200017157805160ff1916838001178555620001a1565b82800160010185558215620001a1579182015b82811115620001a157825182559160200191906001019062000184565b50620001af929150620001b3565b5090565b5b80821115620001af5760008155600101620001b4565b80516001600160a01b0381168114620001e257600080fd5b919050565b60008060408385031215620001fa578182fd5b6200020583620001ca565b91506200021560208401620001ca565b90509250929050565b600181811c908216806200023357607f821691505b602082108114156200025557634e487b7160e01b600052602260045260246000fd5b50919050565b612d92806200026b6000396000f3fe608060405234801561001057600080fd5b50600436106101575760003560e01c806349f2553a116100c3578063a22cb4651161007c578063a22cb46514610317578063b20566dc1461032a578063b88d4fde1461033d578063c87b56dd14610350578063e3e2f86414610363578063e985e9c51461037657600080fd5b806349f2553a1461029a578063589a1743146102ad5780636352211e146102d65780636b9a7579146102e957806370a08231146102fc57806395d89b411461030f57600080fd5b806318160ddd1161011557806318160ddd146102305780631c7ef2aa1461024657806323b872dd1461024e5780633fa2963f1461026157806342842e0e1461027457806342966c681461028757600080fd5b80625d11cb1461015c57806301ffc9a71461017157806306fdde0314610199578063081812fc146101ae578063095ea7b3146101d957806314db9cc8146101ec575b600080fd5b61016f61016a366004612136565b6103b2565b005b61018461017f366004612086565b6105a2565b60405190151581526020015b60405180910390f35b6101a16105f4565b6040516101909190612284565b6101c16101bc366004612136565b610686565b6040516001600160a01b039091168152602001610190565b61016f6101e736600461203f565b61070e565b6101ff6101fa366004612136565b610824565b6040805195865260208601949094529284019190915260608301526001600160a01b0316608082015260a001610190565b610238610904565b604051908152602001610190565b6101a1610914565b61016f61025c366004611f55565b610923565b61023861026f3660046120f1565b610954565b61016f610282366004611f55565b610b28565b61016f610295366004612136565b610b43565b61016f6102a83660046120be565b610d60565b6101c16102bb366004612136565b6000908152600d60205260409020546001600160a01b031690565b6101c16102e4366004612136565b610e4e565b61016f6102f7366004612166565b610ec5565b61023861030a366004611ee5565b611083565b6101a161110a565b61016f610325366004612012565b611119565b600a546101c1906001600160a01b031681565b61016f61034b366004611f95565b6111de565b6101a161035e366004612136565b611216565b6009546101c1906001600160a01b031681565b610184610384366004611f1d565b6001600160a01b03918216600090815260056020908152604080832093909416825291909152205460ff1690565b6103ba610904565b8111156104025760405162461bcd60e51b81526020600482015260116024820152703737b732bc34b9ba32b73a103a37b5b2b760791b60448201526064015b60405180910390fd5b6000818152600c60205260409020546001600160a01b03161561045f5760405162461bcd60e51b81526020600482015260156024820152740436f6d6d656e747320616c7265647920736574757605c1b60448201526064016103f9565b3361046982610e4e565b6001600160a01b0316146104bf5760405162461bcd60e51b815260206004820152601c60248201527f4974277320706f737369626c65206f6e6c7920666f72206f776e65720000000060448201526064016103f9565b60006040516104cd90611d73565b604051809103906000f0801580156104e9573d6000803e3d6000fd5b506000838152600c60205260409081902080546001600160a01b0319166001600160a01b0384811691909117909155600a5482516368a33ee160e11b81526004810193909352601660448401527513919517d0d49150551157d0511117d0d3d35351539560521b6064840152336024840152929350919091169063d1467dc290608401600060405180830381600087803b15801561058657600080fd5b505af115801561059a573d6000803e3d6000fd5b505050505050565b60006001600160e01b031982166380ac58cd60e01b14806105d357506001600160e01b03198216635b5e139f60e01b145b806105ee57506301ffc9a760e01b6001600160e01b03198316145b92915050565b6060600080546106039061241f565b80601f016020809104026020016040519081016040528092919081815260200182805461062f9061241f565b801561067c5780601f106106515761010080835404028352916020019161067c565b820191906000526020600020905b81548152906001019060200180831161065f57829003601f168201915b5050505050905090565b600061069182611250565b6106f25760405162461bcd60e51b815260206004820152602c60248201527f4552433732313a20617070726f76656420717565727920666f72206e6f6e657860448201526b34b9ba32b73a103a37b5b2b760a11b60648201526084016103f9565b506000908152600460205260409020546001600160a01b031690565b600061071982610e4e565b9050806001600160a01b0316836001600160a01b031614156107875760405162461bcd60e51b815260206004820152602160248201527f4552433732313a20617070726f76616c20746f2063757272656e74206f776e656044820152603960f91b60648201526084016103f9565b336001600160a01b03821614806107a357506107a38133610384565b6108155760405162461bcd60e51b815260206004820152603860248201527f4552433732313a20617070726f76652063616c6c6572206973206e6f74206f7760448201527f6e6572206e6f7220617070726f76656420666f7220616c6c000000000000000060648201526084016103f9565b61081f838361126d565b505050565b6000818152600c602052604081205481908190819081906001600160a01b03166108605760405162461bcd60e51b81526004016103f99061231c565b6000868152600c60205260408082205481516311234b7960e11b815291516001600160a01b03909116929182918291859163224696f291600480820192606092909190829003018186803b1580156108b757600080fd5b505afa1580156108cb573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906108ef91906121bf565b9b9c919b909a50985093965092945050505050565b600061090f60085490565b905090565b6060600780546106039061241f565b61092d33826112db565b6109495760405162461bcd60e51b81526004016103f99061235f565b61081f838383611440565b60008061096060085490565b90508215610a5857600a54604080516368a33ee160e11b81526004810191909152601760448201527f4e46545f4352454154455f574954485f434f4d4d454e5400000000000000000060648201523360248201526001600160a01b039091169063d1467dc290608401600060405180830381600087803b1580156109e357600080fd5b505af11580156109f7573d6000803e3d6000fd5b505050506000604051610a0990611d73565b604051809103906000f080158015610a25573d6000803e3d6000fd5b506000838152600c6020526040902080546001600160a01b0319166001600160a01b039290921691909117905550610ad9565b600a8054604080516368a33ee160e11b815260048101919091526044810192909252694e46545f43524541544560b01b60648301523360248301526001600160a01b03169063d1467dc290608401600060405180830381600087803b158015610ac057600080fd5b505af1158015610ad4573d6000803e3d6000fd5b505050505b6000818152600d6020526040902080546001600160a01b03191633908117909155610b0490826115e0565b610b0e81856115fa565b610b1c600880546001019055565b6008545b949350505050565b61081f838383604051806020016040528060008152506111de565b33610b4d82610e4e565b6001600160a01b031614610ba35760405162461bcd60e51b815260206004820152601c60248201527f4974277320706f737369626c65206f6e6c7920666f72206f776e65720000000060448201526064016103f9565b6009546040516370a0823160e01b81523360048201526000916001600160a01b0316906370a082319060240160206040518083038186803b158015610be757600080fd5b505afa158015610bfb573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610c1f919061214e565b90506000600a60009054906101000a90046001600160a01b03166001600160a01b031663d232bc246040518163ffffffff1660e01b815260040160206040518083038186803b158015610c7157600080fd5b505afa158015610c85573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610ca9919061214e565b905080821015610cf35760405162461bcd60e51b81526020600482015260156024820152746e6f7420656e6f7068205041474520746f6b656e7360581b60448201526064016103f9565b600a54604051632770a7eb60e21b8152336004820152602481018390526001600160a01b0390911690639dc29fac90604401600060405180830381600087803b158015610d3f57600080fd5b505af1158015610d53573d6000803e3d6000fd5b5050505061081f83611685565b600a60009054906101000a90046001600160a01b03166001600160a01b0316636e9960c36040518163ffffffff1660e01b815260040160206040518083038186803b158015610dae57600080fd5b505afa158015610dc2573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610de69190611f01565b6001600160a01b0316336001600160a01b031614610e375760405162461bcd60e51b815260206004820152600e60248201526d37b7363c903337b91030b236b4b760911b60448201526064016103f9565b8051610e4a906007906020840190611d81565b5050565b6000818152600260205260408120546001600160a01b0316806105ee5760405162461bcd60e51b815260206004820152602960248201527f4552433732313a206f776e657220717565727920666f72206e6f6e657869737460448201526832b73a103a37b5b2b760b91b60648201526084016103f9565b610ecd610904565b831115610f105760405162461bcd60e51b81526020600482015260116024820152703737b732bc34b9ba32b73a103a37b5b2b760791b60448201526064016103f9565b6000838152600c60205260409020546001600160a01b0316610f445760405162461bcd60e51b81526004016103f99061231c565b6000838152600c602052604090819020549051634ca06ce160e11b81526001600160a01b03909116908190639940d9c290610f8790869086903390600401612297565b600060405180830381600087803b158015610fa157600080fd5b505af1158015610fb5573d6000803e3d6000fd5b5050600a546001600160a01b0316915063c415240c905033610fd687610e4e565b6000888152600d60205260409020546001600160a01b031660405160e085901b6001600160e01b031916815260806004820152600f60848201526e13919517d0511117d0d3d353515395608a1b60a48201526001600160a01b0393841660248201529183166044830152909116606482015260c401600060405180830381600087803b15801561106557600080fd5b505af1158015611079573d6000803e3d6000fd5b5050505050505050565b60006001600160a01b0382166110ee5760405162461bcd60e51b815260206004820152602a60248201527f4552433732313a2062616c616e636520717565727920666f7220746865207a65604482015269726f206164647265737360b01b60648201526084016103f9565b506001600160a01b031660009081526003602052604090205490565b6060600180546106039061241f565b6001600160a01b0382163314156111725760405162461bcd60e51b815260206004820152601960248201527f4552433732313a20617070726f766520746f2063616c6c65720000000000000060448201526064016103f9565b3360008181526005602090815260408083206001600160a01b03871680855290835292819020805460ff191686151590811790915590519081529192917f17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31910160405180910390a35050565b6111e833836112db565b6112045760405162461bcd60e51b81526004016103f99061235f565b61121084848484611691565b50505050565b6060611220610914565b611229836116c4565b60405160200161123a929190612218565b6040516020818303038152906040529050919050565b6000908152600260205260409020546001600160a01b0316151590565b600081815260046020526040902080546001600160a01b0319166001600160a01b03841690811790915581906112a282610e4e565b6001600160a01b03167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560405160405180910390a45050565b60006112e682611250565b6113475760405162461bcd60e51b815260206004820152602c60248201527f4552433732313a206f70657261746f7220717565727920666f72206e6f6e657860448201526b34b9ba32b73a103a37b5b2b760a11b60648201526084016103f9565b600061135283610e4e565b9050806001600160a01b0316846001600160a01b0316148061138d5750836001600160a01b031661138284610686565b6001600160a01b0316145b806113bd57506001600160a01b0380821660009081526005602090815260408083209388168352929052205460ff165b80610b205750600b54604051631da68a2b60e21b81526001600160a01b0386811660048301529091169063769a28ac9060240160206040518083038186803b15801561140857600080fd5b505afa15801561141c573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610b20919061206a565b826001600160a01b031661145382610e4e565b6001600160a01b0316146114bb5760405162461bcd60e51b815260206004820152602960248201527f4552433732313a207472616e73666572206f6620746f6b656e2074686174206960448201526839903737ba1037bbb760b91b60648201526084016103f9565b6001600160a01b03821661151d5760405162461bcd60e51b8152602060048201526024808201527f4552433732313a207472616e7366657220746f20746865207a65726f206164646044820152637265737360e01b60648201526084016103f9565b61152860008261126d565b6001600160a01b03831660009081526003602052604081208054600192906115519084906123dc565b90915550506001600160a01b038216600090815260036020526040812080546001929061157f9084906123b0565b909155505060008181526002602052604080822080546001600160a01b0319166001600160a01b0386811691821790925591518493918716917fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef91a4505050565b610e4a828260405180602001604052806000815250611833565b61160382611250565b6116665760405162461bcd60e51b815260206004820152602e60248201527f45524337323155524953746f726167653a2055524920736574206f66206e6f6e60448201526d32bc34b9ba32b73a103a37b5b2b760911b60648201526084016103f9565b6000828152600660209081526040909120825161081f92840190611d81565b61168e81611866565b50565b61169c848484611440565b6116a8848484846118a6565b6112105760405162461bcd60e51b81526004016103f9906122ca565b60606116cf82611250565b6117355760405162461bcd60e51b815260206004820152603160248201527f45524337323155524953746f726167653a2055524920717565727920666f72206044820152703737b732bc34b9ba32b73a103a37b5b2b760791b60648201526084016103f9565b6000828152600660205260408120805461174e9061241f565b80601f016020809104026020016040519081016040528092919081815260200182805461177a9061241f565b80156117c75780601f1061179c576101008083540402835291602001916117c7565b820191906000526020600020905b8154815290600101906020018083116117aa57829003601f168201915b5050505050905060006117e560408051602081019091526000815290565b90508051600014156117f8575092915050565b81511561182a578082604051602001611812929190612218565b60405160208183030381529060405292505050919050565b610b20846119b3565b61183d8383611a8b565b61184a60008484846118a6565b61081f5760405162461bcd60e51b81526004016103f9906122ca565b61186f81611bbe565b600081815260066020526040902080546118889061241f565b15905061168e57600081815260066020526040812061168e91611e05565b60006001600160a01b0384163b156119a857604051630a85bd0160e11b81526001600160a01b0385169063150b7a02906118ea903390899088908890600401612247565b602060405180830381600087803b15801561190457600080fd5b505af1925050508015611934575060408051601f3d908101601f19168201909252611931918101906120a2565b60015b61198e573d808015611962576040519150601f19603f3d011682016040523d82523d6000602084013e611967565b606091505b5080516119865760405162461bcd60e51b81526004016103f9906122ca565b805181602001fd5b6001600160e01b031916630a85bd0160e11b149050610b20565b506001949350505050565b60606119be82611250565b611a225760405162461bcd60e51b815260206004820152602f60248201527f4552433732314d657461646174613a2055524920717565727920666f72206e6f60448201526e3732bc34b9ba32b73a103a37b5b2b760891b60648201526084016103f9565b6000611a3960408051602081019091526000815290565b90506000815111611a595760405180602001604052806000815250611a84565b80611a6384611c59565b604051602001611a74929190612218565b6040516020818303038152906040525b9392505050565b6001600160a01b038216611ae15760405162461bcd60e51b815260206004820181905260248201527f4552433732313a206d696e7420746f20746865207a65726f206164647265737360448201526064016103f9565b611aea81611250565b15611b375760405162461bcd60e51b815260206004820152601c60248201527f4552433732313a20746f6b656e20616c7265616479206d696e7465640000000060448201526064016103f9565b6001600160a01b0382166000908152600360205260408120805460019290611b609084906123b0565b909155505060008181526002602052604080822080546001600160a01b0319166001600160a01b03861690811790915590518392907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908290a45050565b6000611bc982610e4e565b9050611bd660008361126d565b6001600160a01b0381166000908152600360205260408120805460019290611bff9084906123dc565b909155505060008281526002602052604080822080546001600160a01b0319169055518391906001600160a01b038416907fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef908390a45050565b606081611c7d5750506040805180820190915260018152600360fc1b602082015290565b8160005b8115611ca75780611c918161245a565b9150611ca09050600a836123c8565b9150611c81565b60008167ffffffffffffffff811115611cd057634e487b7160e01b600052604160045260246000fd5b6040519080825280601f01601f191660200182016040528015611cfa576020820181803683370190505b5090505b8415610b2057611d0f6001836123dc565b9150611d1c600a86612475565b611d279060306123b0565b60f81b818381518110611d4a57634e487b7160e01b600052603260045260246000fd5b60200101906001600160f81b031916908160001a905350611d6c600a866123c8565b9450611cfe565b610858806200250583390190565b828054611d8d9061241f565b90600052602060002090601f016020900481019282611daf5760008555611df5565b82601f10611dc857805160ff1916838001178555611df5565b82800160010185558215611df5579182015b82811115611df5578251825591602001919060010190611dda565b50611e01929150611e3b565b5090565b508054611e119061241f565b6000825580601f10611e21575050565b601f01602090049060005260206000209081019061168e91905b5b80821115611e015760008155600101611e3c565b600067ffffffffffffffff80841115611e6b57611e6b6124b5565b604051601f8501601f19908116603f01168101908282118183101715611e9357611e936124b5565b81604052809350858152868686011115611eac57600080fd5b858560208301376000602087830101525050509392505050565b600082601f830112611ed6578081fd5b611a8483833560208501611e50565b600060208284031215611ef6578081fd5b8135611a84816124cb565b600060208284031215611f12578081fd5b8151611a84816124cb565b60008060408385031215611f2f578081fd5b8235611f3a816124cb565b91506020830135611f4a816124cb565b809150509250929050565b600080600060608486031215611f69578081fd5b8335611f74816124cb565b92506020840135611f84816124cb565b929592945050506040919091013590565b60008060008060808587031215611faa578081fd5b8435611fb5816124cb565b93506020850135611fc5816124cb565b925060408501359150606085013567ffffffffffffffff811115611fe7578182fd5b8501601f81018713611ff7578182fd5b61200687823560208401611e50565b91505092959194509250565b60008060408385031215612024578182fd5b823561202f816124cb565b91506020830135611f4a816124e0565b60008060408385031215612051578182fd5b823561205c816124cb565b946020939093013593505050565b60006020828403121561207b578081fd5b8151611a84816124e0565b600060208284031215612097578081fd5b8135611a84816124ee565b6000602082840312156120b3578081fd5b8151611a84816124ee565b6000602082840312156120cf578081fd5b813567ffffffffffffffff8111156120e5578182fd5b610b2084828501611ec6565b60008060408385031215612103578182fd5b823567ffffffffffffffff811115612119578283fd5b61212585828601611ec6565b9250506020830135611f4a816124e0565b600060208284031215612147578081fd5b5035919050565b60006020828403121561215f578081fd5b5051919050565b60008060006060848603121561217a578081fd5b83359250602084013567ffffffffffffffff811115612197578182fd5b6121a386828701611ec6565b92505060408401356121b4816124e0565b809150509250925092565b6000806000606084860312156121d3578081fd5b8351925060208401519150604084015190509250925092565b600081518084526122048160208601602086016123f3565b601f01601f19169290920160200192915050565b6000835161222a8184602088016123f3565b83519083019061223e8183602088016123f3565b01949350505050565b6001600160a01b038581168252841660208201526040810183905260806060820181905260009061227a908301846121ec565b9695505050505050565b602081526000611a8460208301846121ec565b6060815260006122aa60608301866121ec565b9315156020830152506001600160a01b0391909116604090910152919050565b60208082526032908201527f4552433732313a207472616e7366657220746f206e6f6e20455243373231526560408201527131b2b4bb32b91034b6b83632b6b2b73a32b960711b606082015260800190565b60208082526023908201527f4e6f20636f6d6d656e742066756e6374696f6e616c7920666f722074686973206040820152621b999d60ea1b606082015260800190565b60208082526031908201527f4552433732313a207472616e736665722063616c6c6572206973206e6f74206f6040820152701ddb995c881b9bdc88185c1c1c9bdd9959607a1b606082015260800190565b600082198211156123c3576123c3612489565b500190565b6000826123d7576123d761249f565b500490565b6000828210156123ee576123ee612489565b500390565b60005b8381101561240e5781810151838201526020016123f6565b838111156112105750506000910152565b600181811c9082168061243357607f821691505b6020821081141561245457634e487b7160e01b600052602260045260246000fd5b50919050565b600060001982141561246e5761246e612489565b5060010190565b6000826124845761248461249f565b500690565b634e487b7160e01b600052601160045260246000fd5b634e487b7160e01b600052601260045260246000fd5b634e487b7160e01b600052604160045260246000fd5b6001600160a01b038116811461168e57600080fd5b801515811461168e57600080fd5b6001600160e01b03198116811461168e57600080fdfe608060405234801561001057600080fd5b5061001a3361001f565b61006f565b600080546001600160a01b038381166001600160a01b0319831681178455604051919092169283917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09190a35050565b6107da8061007e6000396000f3fe608060405234801561001057600080fd5b50600436106100625760003560e01c8063224696f214610067578063715018a61461008f5780638da5cb5b146100995780639940d9c2146100b4578063c0e7c32d146100c7578063f2fde38b146100ea575b600080fd5b61006f6100fd565b604080519384526020840192909252908201526060015b60405180910390f35b610097610128565b005b6000546040516001600160a01b039091168152602001610086565b6100976100c23660046105bf565b610167565b6100da6100d536600461068c565b61029d565b60405161008694939291906106d9565b6100976100f83660046105a5565b61035c565b600080600061010b60035490565b925061011660045490565b915061012160055490565b9050909192565b6000546001600160a01b0316331461015b5760405162461bcd60e51b8152600401610152906106a4565b60405180910390fd5b61016560006103f7565b565b6000546001600160a01b031633146101915760405162461bcd60e51b8152600401610152906106a4565b600061019c60035490565b6001600160a01b03831660009081526002602052604090209091506101c19082610447565b50604080516080810182528281526001600160a01b03848116602080840191825283850189815288151560608601526000878152600180845296902085518155925195830180546001600160a01b03191696909416959095179092559251805192939261023492600285019201906104e0565b50606091909101516003909101805460ff19169115159190911790556040517fe0a53cd07771af9e14cb32a4254f2ec669df05631af3c2a85448188f097c9ec4906102869083908590889088906106d9565b60405180910390a16102978361045c565b50505050565b60016020819052600091825260409091208054918101546002820180546001600160a01b0390921692916102d090610753565b80601f01602080910402602001604051908101604052809291908181526020018280546102fc90610753565b80156103495780601f1061031e57610100808354040283529160200191610349565b820191906000526020600020905b81548152906001019060200180831161032c57829003601f168201915b5050506003909301549192505060ff1684565b6000546001600160a01b031633146103865760405162461bcd60e51b8152600401610152906106a4565b6001600160a01b0381166103eb5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201526564647265737360d01b6064820152608401610152565b6103f4816103f7565b50565b600080546001600160a01b038381166001600160a01b0319831681178455604051919092169283917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09190a35050565b60006104538383610491565b90505b92915050565b801561047557610470600480546001019055565b610483565b610483600580546001019055565b6103f4600380546001019055565b60008181526001830160205260408120546104d857508154600181810184556000848152602080822090930184905584548482528286019093526040902091909155610456565b506000610456565b8280546104ec90610753565b90600052602060002090601f01602090048101928261050e5760008555610554565b82601f1061052757805160ff1916838001178555610554565b82800160010185558215610554579182015b82811115610554578251825591602001919060010190610539565b50610560929150610564565b5090565b5b808211156105605760008155600101610565565b80356001600160a01b038116811461059057600080fd5b919050565b8035801515811461059057600080fd5b6000602082840312156105b6578081fd5b61045382610579565b6000806000606084860312156105d3578182fd5b833567ffffffffffffffff808211156105ea578384fd5b818601915086601f8301126105fd578384fd5b81358181111561060f5761060f61078e565b604051601f8201601f19908116603f011681019083821181831017156106375761063761078e565b8160405282815289602084870101111561064f578687fd5b826020860160208301378660208483010152809750505050505061067560208501610595565b915061068360408501610579565b90509250925092565b60006020828403121561069d578081fd5b5035919050565b6020808252818101527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572604082015260600190565b8481526000602060018060a01b03861681840152608060408401528451806080850152825b8181101561071a5786810183015185820160a0015282016106fe565b8181111561072b578360a083870101525b50601f01601f1916830160a001915061074a9050606083018415159052565b95945050505050565b600181811c9082168061076757607f821691505b6020821081141561078857634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052604160045260246000fdfea2646970667358221220434a3dd37887281b0418c1df25c8ad460a93b99be6a29f79058aa3ac82e6b58064736f6c63430008040033a26469706673582212208889c2b3b6892868bff6a275a6a2ebd4495a127205e723d5e0f8879e641af57064736f6c63430008040033";

type PageMinterNFTConstructorParams =
    | [signer?: Signer]
    | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
    xs: PageMinterNFTConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class PageMinterNFT__factory extends ContractFactory {
    constructor(...args: PageMinterNFTConstructorParams) {
        if (isSuperArgs(args)) {
            super(...args);
        } else {
            super(_abi, _bytecode, args[0]);
        }
    }

    deploy(
        _PAGE_MINTER: string,
        _PAGE_TOKEN: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PageMinterNFT> {
        return super.deploy(
            _PAGE_MINTER,
            _PAGE_TOKEN,
            overrides || {}
        ) as Promise<PageMinterNFT>;
    }
    getDeployTransaction(
        _PAGE_MINTER: string,
        _PAGE_TOKEN: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): TransactionRequest {
        return super.getDeployTransaction(
            _PAGE_MINTER,
            _PAGE_TOKEN,
            overrides || {}
        );
    }
    attach(address: string): PageMinterNFT {
        return super.attach(address) as PageMinterNFT;
    }
    connect(signer: Signer): PageMinterNFT__factory {
        return super.connect(signer) as PageMinterNFT__factory;
    }
    static readonly bytecode = _bytecode;
    static readonly abi = _abi;
    static createInterface(): PageMinterNFTInterface {
        return new utils.Interface(_abi) as PageMinterNFTInterface;
    }
    static connect(
        address: string,
        signerOrProvider: Signer | Provider
    ): PageMinterNFT {
        return new Contract(address, _abi, signerOrProvider) as PageMinterNFT;
    }
}
