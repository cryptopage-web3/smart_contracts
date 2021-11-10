/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PageAdmin, PageAdminInterface } from "../PageAdmin";

const _abi = [
    {
        inputs: [
            {
                internalType: "address",
                name: "_TreasuryAddress",
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
                name: "previousOwner",
                type: "address",
            },
            {
                indexed: true,
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "OwnershipTransferred",
        type: "event",
    },
    {
        inputs: [],
        name: "PAGE_MINTER",
        outputs: [
            {
                internalType: "contract PageMinter",
                name: "",
                type: "address",
            },
        ],
        stateMutability: "view",
        type: "function",
    },
    {
        inputs: [],
        name: "PAGE_NFT",
        outputs: [
            {
                internalType: "contract INFTMINT",
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
        name: "TreasuryAddress",
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
                internalType: "address[]",
                name: "_safe",
                type: "address[]",
            },
        ],
        name: "addSafe",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_from",
                type: "address",
            },
            {
                internalType: "address",
                name: "_to",
                type: "address",
            },
        ],
        name: "changeSafe",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_PAGE_NFT",
                type: "address",
            },
            {
                internalType: "address",
                name: "_PAGE_TOKEN",
                type: "address",
            },
        ],
        name: "init",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "owner",
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
        ],
        name: "removeMinter",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_safe",
                type: "address",
            },
        ],
        name: "removeSafe",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [],
        name: "renounceOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_pageamount",
                type: "uint256",
            },
        ],
        name: "setBurnNFTcost",
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
        ],
        name: "setMinter",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "string",
                name: "_url",
                type: "string",
            },
        ],
        name: "setNftBaseURL",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "_treasury",
                type: "address",
            },
        ],
        name: "setTreasuryAddress",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "uint256",
                name: "_percent",
                type: "uint256",
            },
        ],
        name: "setTreasuryFee",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
    {
        inputs: [
            {
                internalType: "address",
                name: "newOwner",
                type: "address",
            },
        ],
        name: "transferOwnership",
        outputs: [],
        stateMutability: "nonpayable",
        type: "function",
    },
];

const _bytecode =
    "0x60806040526004805460ff60a01b1916600160a01b17905534801561002357600080fd5b506040516132363803806132368339810160408190526100429161012d565b61004b336100d0565b600480546001600160a01b0319166001600160a01b0383161790556040513090829061007690610120565b6001600160a01b03928316815291166020820152604001604051809103906000f0801580156100a9573d6000803e3d6000fd5b50600180546001600160a01b0319166001600160a01b03929092169190911790555061015b565b600080546001600160a01b038381166001600160a01b0319831681178455604051919092169283917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09190a35050565b61232680610f1083390190565b60006020828403121561013e578081fd5b81516001600160a01b0381168114610154578182fd5b9392505050565b610da68061016a6000396000f3fe608060405234801561001057600080fd5b506004361061010b5760003560e01c80638da5cb5b116100a2578063baa0f6d811610071578063baa0f6d814610205578063d255107414610218578063e3e2f8641461022b578063f09a40161461023e578063f2fde38b1461025157600080fd5b80638da5cb5b146101bb57806393ebc444146101cc578063a3ca9b2b146101df578063b20566dc146101f257600080fd5b80635b5c251f116100de5780635b5c251f1461017a5780636605bfda1461018d578063715018a6146101a057806377e741c7146101a857600080fd5b80630b1de114146101105780630df8b91c14610125578063288329931461015457806335d2325914610167575b600080fd5b61012361011e366004610bc0565b610264565b005b600354610138906001600160a01b031681565b6040516001600160a01b03909116815260200160405180910390f35b610123610162366004610a81565b6102f9565b610123610175366004610b30565b61037d565b600454610138906001600160a01b031681565b61012361019b366004610a2e565b610401565b610123610487565b6101236101b6366004610bc0565b6104bd565b6000546001600160a01b0316610138565b6101236101da366004610b30565b610542565b6101236101ed366004610a4f565b61059c565b600154610138906001600160a01b031681565b610123610213366004610a2e565b61065b565b610123610226366004610b6b565b6106e1565b600254610138906001600160a01b031681565b61012361024c366004610a4f565b6107a3565b61012361025f366004610a2e565b6108bc565b6000546001600160a01b031633146102975760405162461bcd60e51b815260040161028e90610cf4565b60405180910390fd5b600154604051631d865feb60e11b8152600481018390526001600160a01b0390911690633b0cbfd6906024015b600060405180830381600087803b1580156102de57600080fd5b505af11580156102f2573d6000803e3d6000fd5b5050505050565b6000546001600160a01b031633146103235760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff161561034d5760405162461bcd60e51b815260040161028e90610cbd565b600154604051632883299360e01b81526001600160a01b03909116906328832993906102c4908490600401610c23565b6000546001600160a01b031633146103a75760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156103d15760405162461bcd60e51b815260040161028e90610cbd565b6001546040516335d2325960e01b81526001600160a01b03909116906335d23259906102c4908490600401610c70565b6000546001600160a01b0316331461042b5760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156104555760405162461bcd60e51b815260040161028e90610cbd565b600154604051633302dfed60e11b81526001600160a01b03838116600483015290911690636605bfda906024016102c4565b6000546001600160a01b031633146104b15760405162461bcd60e51b815260040161028e90610cf4565b6104bb6000610957565b565b6000546001600160a01b031633146104e75760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156105115760405162461bcd60e51b815260040161028e90610cbd565b6001546040516377e741c760e01b8152600481018390526001600160a01b03909116906377e741c7906024016102c4565b6000546001600160a01b0316331461056c5760405162461bcd60e51b815260040161028e90610cf4565b6003546040516324f92a9d60e11b81526001600160a01b03909116906349f2553a906102c4908490600401610c70565b6000546001600160a01b031633146105c65760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156105f05760405162461bcd60e51b815260040161028e90610cbd565b60015460405163a3ca9b2b60e01b81526001600160a01b03848116600483015283811660248301529091169063a3ca9b2b90604401600060405180830381600087803b15801561063f57600080fd5b505af1158015610653573d6000803e3d6000fd5b505050505050565b6000546001600160a01b031633146106855760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156106af5760405162461bcd60e51b815260040161028e90610cbd565b6001546040516317541edb60e31b81526001600160a01b0383811660048301529091169063baa0f6d8906024016102c4565b6000546001600160a01b0316331461070b5760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff16156107355760405162461bcd60e51b815260040161028e90610cbd565b600154604051634cc1733b60e11b81526001600160a01b0390911690639982e6769061076c90869086908690600090600401610c83565b600060405180830381600087803b15801561078657600080fd5b505af115801561079a573d6000803e3d6000fd5b50505050505050565b6000546001600160a01b031633146107cd5760405162461bcd60e51b815260040161028e90610cf4565b600454600160a01b900460ff1661081e5760405162461bcd60e51b815260206004820152601560248201527443414e2042452043414c4c204f4e4c59204f4e434560581b604482015260640161028e565b600380546001600160a01b038481166001600160a01b031992831681179093556002805485831693168317905560015460405163784d200b60e11b815260048101939093526024830193909352919091169063f09a401690604401600060405180830381600087803b15801561089357600080fd5b505af11580156108a7573d6000803e3d6000fd5b50506004805460ff60a01b1916905550505050565b6000546001600160a01b031633146108e65760405162461bcd60e51b815260040161028e90610cf4565b6001600160a01b03811661094b5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201526564647265737360d01b606482015260840161028e565b61095481610957565b50565b600080546001600160a01b038381166001600160a01b0319831681178455604051919092169283917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e09190a35050565b80356001600160a01b03811681146109be57600080fd5b919050565b600082601f8301126109d3578081fd5b813567ffffffffffffffff8111156109ed576109ed610d5a565b610a00601f8201601f1916602001610d29565b818152846020838601011115610a14578283fd5b816020850160208301379081016020019190915292915050565b600060208284031215610a3f578081fd5b610a48826109a7565b9392505050565b60008060408385031215610a61578081fd5b610a6a836109a7565b9150610a78602084016109a7565b90509250929050565b60006020808385031215610a93578182fd5b823567ffffffffffffffff80821115610aaa578384fd5b818501915085601f830112610abd578384fd5b813581811115610acf57610acf610d5a565b8060051b9150610ae0848301610d29565b8181528481019084860184860187018a1015610afa578788fd5b8795505b83861015610b2357610b0f816109a7565b835260019590950194918601918601610afe565b5098975050505050505050565b600060208284031215610b41578081fd5b813567ffffffffffffffff811115610b57578182fd5b610b63848285016109c3565b949350505050565b600080600060608486031215610b7f578081fd5b833567ffffffffffffffff811115610b95578182fd5b610ba1868287016109c3565b935050610bb0602085016109a7565b9150604084013590509250925092565b600060208284031215610bd1578081fd5b5035919050565b60008151808452815b81811015610bfd57602081850181015186830182015201610be1565b81811115610c0e5782602083870101525b50601f01601f19169290920160200192915050565b6020808252825182820181905260009190848201906040850190845b81811015610c645783516001600160a01b031683529284019291840191600101610c3f565b50909695505050505050565b602081526000610a486020830184610bd8565b608081526000610c966080830187610bd8565b6001600160a01b039590951660208301525060408101929092521515606090910152919050565b60208082526018908201527f494e49542046554e4354494f4e204e4f542043414c4c45440000000000000000604082015260600190565b6020808252818101527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e6572604082015260600190565b604051601f8201601f1916810167ffffffffffffffff81118282101715610d5257610d52610d5a565b604052919050565b634e487b7160e01b600052604160045260246000fdfea2646970667358221220b3b52812bd21c4f1acc91d5df27c508b3acb9aaed5bbc69737b2aaae653cbe5564736f6c634300080400336080604052600180546001600160a01b03199081169091556002805490911690556103e86003556008805460ff191690553480156200003d57600080fd5b5060405162002326380380620023268339810160408190526200006091620000af565b600280546001600160a01b039384166001600160a01b03199182161790915560018054929093169116179055620000e6565b80516001600160a01b0381168114620000aa57600080fd5b919050565b60008060408385031215620000c2578182fd5b620000cd8362000092565b9150620000dd6020840162000092565b90509250929050565b61223080620000f66000396000f3fe608060405234801561001057600080fd5b50600436106101a95760003560e01c80639982e676116100f9578063d1467dc211610097578063f09a401611610071578063f09a401614610403578063f231666314610416578063f2fb904614610429578063f6350b991461043157600080fd5b8063d1467dc2146103df578063d232bc24146103f2578063dcd00268146103fa57600080fd5b8063aab6402a116100d3578063aab6402a14610397578063baa0f6d8146103af578063bd64f48b146103c2578063c415240c146103cc57600080fd5b80639982e6761461035e5780639dc29fac14610371578063a3ca9b2b1461038457600080fd5b80633b0cbfd6116101665780636605bfda116101405780636605bfda146102eb5780636e9960c3146102fe578063769a28ac1461030f57806377e741c71461034b57600080fd5b80633b0cbfd6146102a0578063554403b0146102b35780635b5c251f146102d857600080fd5b806305c07af6146101ae57806305e9afa2146101c357806311cc57f8146101f0578063288329931461026757806335d232591461027a5780633abecd781461028d575b600080fd5b6101c16101bc366004611e49565b610444565b005b6101d66101d1366004611f14565b610691565b604080519283526020830191909152015b60405180910390f35b61023d6101fe366004611c9e565b8051602081830181018051600682529282019190930120915280546001820154600283015460039093015491926001600160a01b039091169160ff1684565b604080519485526001600160a01b03909316602085015291830152151560608201526080016101e7565b6101c1610275366004611c63565b6107aa565b6101c1610288366004611c9e565b61084e565b6101c161029b366004611d14565b610975565b6101c16102ae366004611f57565b610b59565b6000546001600160a01b03165b6040516001600160a01b0390911681526020016101e7565b6001546102c0906001600160a01b031681565b6101c16102f9366004611bee565b610b88565b6002546001600160a01b03166102c0565b61033b61031d366004611bee565b6001600160a01b031660009081526009602052604090205460ff1690565b60405190151581526020016101e7565b6101c1610359366004611f57565b610c36565b6101c161036c366004611ddd565b610d41565b6101c161037f366004611c3a565b610ed4565b6101c1610392366004611c08565b611049565b6004546103a19081565b6040519081526020016101e7565b6101c16103bd366004611bee565b6110ae565b6005546103a19081565b6101c16103da366004611d70565b6110f9565b6101c16103ed366004611cd1565b61137c565b600a546103a1565b6103a160035481565b6101c1610411366004611c08565b611535565b6101c1610424366004611eaa565b6116d5565b6103a1611973565b61023d61043f366004611c9e565b611983565b60085460ff1661046f5760405162461bcd60e51b815260040161046690612087565b60405180910390fd5b60078260405161047f9190611f6f565b9081526040519081900360200190205460ff166104ae5760405162461bcd60e51b8152600401610466906120f5565b60006006836040516104c09190611f6f565b9081526020016040518091039020905060008160020154116104f45760405162461bcd60e51b8152600401610466906120be565b60018101546001600160a01b031633146105205760405162461bcd60e51b815260040161046690611fec565b8151600581106105425760405162461bcd60e51b815260040161046690611fc1565b600081116105625760405162461bcd60e51b815260040161046690612058565b60008061056f8684610691565b9150915060005b838110156106205760005486516001600160a01b03909116906340c10f19908890849081106105b557634e487b7160e01b600052603260045260246000fd5b6020026020010151856040518363ffffffff1660e01b81526004016105db929190611fa8565b600060405180830381600087803b1580156105f557600080fd5b505af1158015610609573d6000803e3d6000fd5b505050508080610618906121b3565b915050610576565b506000546001546040516340c10f1960e01b81526001600160a01b03928316926340c10f1992610657929116908590600401611fa8565b600060405180830381600087803b15801561067157600080fd5b505af1158015610685573d6000803e3d6000fd5b50505050505050505050565b6000806007846040516106a49190611f6f565b9081526040519081900360200190205460ff166107035760405162461bcd60e51b815260206004820152601f60248201527f616d6f756e744d696e743a205f6b657920646f65736e277420657869737473006044820152606401610466565b600583106107235760405162461bcd60e51b815260040161046690611fc1565b600083116107435760405162461bcd60e51b815260040161046690612058565b60006006856040516107559190611f6f565b9081526020016040518091039020905061078a6127106107846003548460020154611a6790919063ffffffff16565b90611a7a565b91506107a084838360020154610784919061219c565b9250509250929050565b6002546001600160a01b031633146107d45760405162461bcd60e51b815260040161046690612016565b60005b815181101561084a5760016009600084848151811061080657634e487b7160e01b600052603260045260246000fd5b6020908102919091018101516001600160a01b03168252810191909152604001600020805460ff191691151591909117905580610842816121b3565b9150506107d7565b5050565b6002546001600160a01b031633146108785760405162461bcd60e51b815260040161046690612016565b6007816040516108889190611f6f565b9081526040519081900360200190205460ff166108f15760405162461bcd60e51b815260206004820152602160248201527f72656d6f76654d696e7465723a205f6b657920646f65736e27742065786973746044820152607360f81b6064820152608401610466565b60006007826040516109039190611f6f565b908152604051908190036020018120805492151560ff1990931692909217909155600690610932908390611f6f565b90815260405190819003602001902060008082556001820180546001600160a01b03191690556002820155600301805460ff191690556109726004611a86565b50565b60085460ff166109975760405162461bcd60e51b815260040161046690612087565b6007836040516109a79190611f6f565b9081526040519081900360200190205460ff166109d65760405162461bcd60e51b8152600401610466906120f5565b60006006846040516109e89190611f6f565b908152602001604051809103902090506000816002015411610a1c5760405162461bcd60e51b8152600401610466906120be565b60018101546001600160a01b03163314610a485760405162461bcd60e51b815260040161046690611fec565b600080610a56866002610691565b6000546040516340c10f1960e01b81529294509092506001600160a01b0316906340c10f1990610a8c9088908690600401611fa8565b600060405180830381600087803b158015610aa657600080fd5b505af1158015610aba573d6000803e3d6000fd5b50506000546040516340c10f1960e01b81526001600160a01b0390911692506340c10f199150610af09087908690600401611fa8565b600060405180830381600087803b158015610b0a57600080fd5b505af1158015610b1e573d6000803e3d6000fd5b50506000546001546040516340c10f1960e01b81526001600160a01b0392831694506340c10f19935061065792909116908590600401611fa8565b6002546001600160a01b03163314610b835760405162461bcd60e51b815260040161046690612016565b600a55565b6002546001600160a01b03163314610bb25760405162461bcd60e51b815260040161046690612016565b6001600160a01b038116610c145760405162461bcd60e51b815260206004820152602360248201527f7365745472656173757279416464726573733a206973207a65726f206164647260448201526265737360e81b6064820152608401610466565b600180546001600160a01b0319166001600160a01b0392909216919091179055565b6002546001600160a01b03163314610c605760405162461bcd60e51b815260040161046690612016565b600a811015610cce5760405162461bcd60e51b815260206004820152603460248201527f73657454726561737572794665653a206d696e696d756d207472656173757279604482015273206665652070657263656e7420697320302e312560601b6064820152608401610466565b610bb8811115610d3c5760405162461bcd60e51b815260206004820152603360248201527f73657454726561737572794665653a206d6178696d756d207472656173757279604482015272206665652070657263656e742069732033302560681b6064820152608401610466565b600355565b6002546001600160a01b03163314610d6b5760405162461bcd60e51b815260040161046690612016565b600784604051610d7b9190611f6f565b9081526040519081900360200190205460ff1615610de3576000600685604051610da59190611f6f565b9081526040805191829003602090810183206080840183525483529082018590526001600160a01b0386169082015282151560609091015250610ece565b6001600785604051610df59190611f6f565b90815260408051918290036020018220805493151560ff19909416939093179092556080810190915280610e2860055490565b8152602001846001600160a01b03168152602001838152602001821515815250600685604051610e589190611f6f565b90815260408051602092819003830190208351815591830151600180840180546001600160a01b0319166001600160a01b03909316929092179091559083015160028301556060909201516003909101805460ff1916911515919091179055600580549091019055610ece600480546001019055565b50505050565b3360009081526009602052604090205460ff16610f3f5760405162461bcd60e51b8152602060048201526024808201527f6f6e6c79536166653a2063616c6c6572206973206e6f7420696e2073616665206044820152631b1a5cdd60e21b6064820152608401610466565b60085460ff16610f615760405162461bcd60e51b815260040161046690612087565b60005460405163040d976b60e01b81526001600160a01b039091169063040d976b90610f939085908590600401611fa8565b600060405180830381600087803b158015610fad57600080fd5b505af1158015610fc1573d6000803e3d6000fd5b50506000546001546003546001600160a01b0392831694506340c10f199350911690610ff69061271090610784908790611a67565b6040518363ffffffff1660e01b8152600401611013929190611fa8565b600060405180830381600087803b15801561102d57600080fd5b505af1158015611041573d6000803e3d6000fd5b505050505050565b6002546001600160a01b031633146110735760405162461bcd60e51b815260040161046690612016565b6001600160a01b03918216600090815260096020526040808220805460ff199081169091559290931681529190912080549091166001179055565b6002546001600160a01b031633146110d85760405162461bcd60e51b815260040161046690612016565b6001600160a01b03166000908152600960205260409020805460ff19169055565b60085460ff1661111b5760405162461bcd60e51b815260040161046690612087565b60078460405161112b9190611f6f565b9081526040519081900360200190205460ff1661115a5760405162461bcd60e51b8152600401610466906120f5565b600060068560405161116c9190611f6f565b9081526020016040518091039020905060008160020154116111a05760405162461bcd60e51b8152600401610466906120be565b60018101546001600160a01b031633146111cc5760405162461bcd60e51b815260040161046690611fec565b6000806111da876003610691565b6000546040516340c10f1960e01b81529294509092506001600160a01b0316906340c10f19906112109089908690600401611fa8565b600060405180830381600087803b15801561122a57600080fd5b505af115801561123e573d6000803e3d6000fd5b50506000546040516340c10f1960e01b81526001600160a01b0390911692506340c10f1991506112749088908690600401611fa8565b600060405180830381600087803b15801561128e57600080fd5b505af11580156112a2573d6000803e3d6000fd5b50506000546040516340c10f1960e01b81526001600160a01b0390911692506340c10f1991506112d89087908690600401611fa8565b600060405180830381600087803b1580156112f257600080fd5b505af1158015611306573d6000803e3d6000fd5b50506000546001546040516340c10f1960e01b81526001600160a01b0392831694506340c10f19935061134192909116908590600401611fa8565b600060405180830381600087803b15801561135b57600080fd5b505af115801561136f573d6000803e3d6000fd5b5050505050505050505050565b60085460ff1661139e5760405162461bcd60e51b815260040161046690612087565b6007826040516113ae9190611f6f565b9081526040519081900360200190205460ff166113dd5760405162461bcd60e51b8152600401610466906120f5565b60006006836040516113ef9190611f6f565b9081526020016040518091039020905060008160020154116114235760405162461bcd60e51b8152600401610466906120be565b60018101546001600160a01b0316331461144f5760405162461bcd60e51b815260040161046690611fec565b60008061145d856001610691565b6000546040516340c10f1960e01b81529294509092506001600160a01b0316906340c10f19906114939087908690600401611fa8565b600060405180830381600087803b1580156114ad57600080fd5b505af11580156114c1573d6000803e3d6000fd5b50506000546001546040516340c10f1960e01b81526001600160a01b0392831694506340c10f1993506114fc92909116908590600401611fa8565b600060405180830381600087803b15801561151657600080fd5b505af115801561152a573d6000803e3d6000fd5b505050505050505050565b6002546001600160a01b0316331461155f5760405162461bcd60e51b815260040161046690612016565b60085460ff16156115aa5760405162461bcd60e51b815260206004820152601560248201527463616e2062652063616c6c206f6e6c79206f6e636560581b6044820152606401610466565b600080546001600160a01b0319166001600160a01b03841617815560408051808201909152600a8152694e46545f43524541544560b01b60208201526115fb918390678ac7230489e8000090610d41565b6116456040518060400160405280601781526020017f4e46545f4352454154455f574954485f434f4d4d454e5400000000000000000081525082678ac7230489e800006000610d41565b6116886040518060400160405280601681526020017513919517d0d49150551157d0511117d0d3d35351539560521b81525082678ac7230489e800006000610d41565b6116c46040518060400160405280600f81526020016e13919517d0511117d0d3d353515395608a1b81525082678ac7230489e800006000610d41565b50506008805460ff19166001179055565b60085460ff166116f75760405162461bcd60e51b815260040161046690612087565b6007836040516117079190611f6f565b9081526040519081900360200190205460ff166117665760405162461bcd60e51b815260206004820152601a60248201527f6d696e74583a205f6b657920646f65736e2774206578697374730000000000006044820152606401610466565b60006006846040516117789190611f6f565b9081526020016040518091039020905060008160020154116117ac5760405162461bcd60e51b8152600401610466906120be565b60018101546001600160a01b031633146117d85760405162461bcd60e51b815260040161046690611fec565b600381015460ff166118205760405162461bcd60e51b8152602060048201526011602482015270786d696e743a206e6f742061637469766560781b6044820152606401610466565b8251600581106118425760405162461bcd60e51b815260040161046690611fc1565b600081116118625760405162461bcd60e51b815260040161046690612058565b60008061186f8784610691565b9150915060005b838110156119325760005487516001600160a01b03909116906340c10f19908990849081106118b557634e487b7160e01b600052603260045260246000fd5b60200260200101516118d08987611a6790919063ffffffff16565b6040518363ffffffff1660e01b81526004016118ed929190611fa8565b600060405180830381600087803b15801561190757600080fd5b505af115801561191b573d6000803e3d6000fd5b50505050808061192a906121b3565b915050611876565b506000546001546001600160a01b03918216916340c10f1991166119568489611a67565b6040518363ffffffff1660e01b8152600401611341929190611fa8565b600061197e60055490565b905090565b6000806000806007856040516119999190611f6f565b9081526040519081900360200190205460ff166119f85760405162461bcd60e51b815260206004820152601e60248201527f6765744d696e7465723a205f6b657920646f65736e27742065786973747300006044820152606401610466565b6000600686604051611a0a9190611f6f565b9081526040805160209281900383018120608082018352805480835260018201546001600160a01b0316948301859052600282015493830184905260039091015460ff161515606090920182905299929850909650945092505050565b6000611a73828461217d565b9392505050565b6000611a73828461215d565b805480611ad55760405162461bcd60e51b815260206004820152601b60248201527f436f756e7465723a2064656372656d656e74206f766572666c6f7700000000006044820152606401610466565b600019019055565b80356001600160a01b0381168114611af457600080fd5b919050565b600082601f830112611b09578081fd5b8135602067ffffffffffffffff821115611b2557611b256121e4565b8160051b611b3482820161212c565b838152828101908684018388018501891015611b4e578687fd5b8693505b85841015611b7757611b6381611add565b835260019390930192918401918401611b52565b50979650505050505050565b600082601f830112611b93578081fd5b813567ffffffffffffffff811115611bad57611bad6121e4565b611bc0601f8201601f191660200161212c565b818152846020838601011115611bd4578283fd5b816020850160208301379081016020019190915292915050565b600060208284031215611bff578081fd5b611a7382611add565b60008060408385031215611c1a578081fd5b611c2383611add565b9150611c3160208401611add565b90509250929050565b60008060408385031215611c4c578182fd5b611c5583611add565b946020939093013593505050565b600060208284031215611c74578081fd5b813567ffffffffffffffff811115611c8a578182fd5b611c9684828501611af9565b949350505050565b600060208284031215611caf578081fd5b813567ffffffffffffffff811115611cc5578182fd5b611c9684828501611b83565b60008060408385031215611ce3578182fd5b823567ffffffffffffffff811115611cf9578283fd5b611d0585828601611b83565b925050611c3160208401611add565b600080600060608486031215611d28578081fd5b833567ffffffffffffffff811115611d3e578182fd5b611d4a86828701611b83565b935050611d5960208501611add565b9150611d6760408501611add565b90509250925092565b60008060008060808587031215611d85578081fd5b843567ffffffffffffffff811115611d9b578182fd5b611da787828801611b83565b945050611db660208601611add565b9250611dc460408601611add565b9150611dd260608601611add565b905092959194509250565b60008060008060808587031215611df2578384fd5b843567ffffffffffffffff811115611e08578485fd5b611e1487828801611b83565b945050611e2360208601611add565b92506040850135915060608501358015158114611e3e578182fd5b939692955090935050565b60008060408385031215611e5b578182fd5b823567ffffffffffffffff80821115611e72578384fd5b611e7e86838701611b83565b93506020850135915080821115611e93578283fd5b50611ea085828601611af9565b9150509250929050565b600080600060608486031215611ebe578283fd5b833567ffffffffffffffff80821115611ed5578485fd5b611ee187838801611b83565b94506020860135915080821115611ef6578384fd5b50611f0386828701611af9565b925050604084013590509250925092565b60008060408385031215611f26578182fd5b823567ffffffffffffffff811115611f3c578283fd5b611f4885828601611b83565b95602094909401359450505050565b600060208284031215611f68578081fd5b5035919050565b60008251815b81811015611f8f5760208186018101518583015201611f75565b81811115611f9d5782828501525b509190910192915050565b6001600160a01b03929092168252602082015260400190565b6020808252601190820152701859191c995cdcc818dbdd5b9d080f880d607a1b604082015260600190565b60208082526010908201526f36b4b73a1d103737ba1036b4b73a32b960811b604082015260600190565b60208082526022908201527f6f6e6c7941646d696e3a2063616c6c6572206973206e6f74207468652061646d60408201526134b760f11b606082015260800190565b6020808252601590820152746164647265737320636f756e74206973207a65726f60581b604082015260600190565b60208082526018908201527f6e65656420746f20626520696e69742062792061646d696e0000000000000000604082015260600190565b6020808252601e908201527f6d696e743a206d696e7465722e616d6f756e742063616e277420626520300000604082015260600190565b60208082526019908201527f6d696e743a205f6b657920646f65736e27742065786973747300000000000000604082015260600190565b604051601f8201601f1916810167ffffffffffffffff81118282101715612155576121556121e4565b604052919050565b60008261217857634e487b7160e01b81526012600452602481fd5b500490565b6000816000190483118215151615612197576121976121ce565b500290565b6000828210156121ae576121ae6121ce565b500390565b60006000198214156121c7576121c76121ce565b5060010190565b634e487b7160e01b600052601160045260246000fd5b634e487b7160e01b600052604160045260246000fdfea2646970667358221220e47f3fe5005042d717335e5e2118a5e37ee2e36f73b036b1d441d4dfe77f691a64736f6c63430008040033";

type PageAdminConstructorParams =
    | [signer?: Signer]
    | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
    xs: PageAdminConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class PageAdmin__factory extends ContractFactory {
    constructor(...args: PageAdminConstructorParams) {
        if (isSuperArgs(args)) {
            super(...args);
        } else {
            super(_abi, _bytecode, args[0]);
        }
    }

    deploy(
        _TreasuryAddress: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PageAdmin> {
        return super.deploy(
            _TreasuryAddress,
            overrides || {}
        ) as Promise<PageAdmin>;
    }
    getDeployTransaction(
        _TreasuryAddress: string,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): TransactionRequest {
        return super.getDeployTransaction(_TreasuryAddress, overrides || {});
    }
    attach(address: string): PageAdmin {
        return super.attach(address) as PageAdmin;
    }
    connect(signer: Signer): PageAdmin__factory {
        return super.connect(signer) as PageAdmin__factory;
    }
    static readonly bytecode = _bytecode;
    static readonly abi = _abi;
    static createInterface(): PageAdminInterface {
        return new utils.Interface(_abi) as PageAdminInterface;
    }
    static connect(
        address: string,
        signerOrProvider: Signer | Provider
    ): PageAdmin {
        return new Contract(address, _abi, signerOrProvider) as PageAdmin;
    }
}