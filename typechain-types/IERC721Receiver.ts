/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
    ethers,
    EventFilter,
    Signer,
    BigNumber,
    BigNumberish,
    PopulatedTransaction,
    BaseContract,
    ContractTransaction,
    Overrides,
    CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type {
    TypedEventFilter,
    TypedEvent,
    TypedListener,
    OnEvent,
} from "./common";

export interface IERC721ReceiverInterface extends ethers.utils.Interface {
    functions: {
        "onERC721Received(address,address,uint256,bytes)": FunctionFragment;
    };

    encodeFunctionData(
        functionFragment: "onERC721Received",
        values: [string, string, BigNumberish, BytesLike]
    ): string;

    decodeFunctionResult(
        functionFragment: "onERC721Received",
        data: BytesLike
    ): Result;

    events: {};
}

export interface IERC721Receiver extends BaseContract {
    connect(signerOrProvider: Signer | Provider | string): this;
    attach(addressOrName: string): this;
    deployed(): Promise<this>;

    interface: IERC721ReceiverInterface;

    queryFilter<TEvent extends TypedEvent>(
        event: TypedEventFilter<TEvent>,
        fromBlockOrBlockhash?: string | number | undefined,
        toBlock?: string | number | undefined
    ): Promise<Array<TEvent>>;

    listeners<TEvent extends TypedEvent>(
        eventFilter?: TypedEventFilter<TEvent>
    ): Array<TypedListener<TEvent>>;
    listeners(eventName?: string): Array<Listener>;
    removeAllListeners<TEvent extends TypedEvent>(
        eventFilter: TypedEventFilter<TEvent>
    ): this;
    removeAllListeners(eventName?: string): this;
    off: OnEvent<this>;
    on: OnEvent<this>;
    once: OnEvent<this>;
    removeListener: OnEvent<this>;

    functions: {
        onERC721Received(
            operator: string,
            from: string,
            tokenId: BigNumberish,
            data: BytesLike,
            overrides?: Overrides & { from?: string | Promise<string> }
        ): Promise<ContractTransaction>;
    };

    onERC721Received(
        operator: string,
        from: string,
        tokenId: BigNumberish,
        data: BytesLike,
        overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    callStatic: {
        onERC721Received(
            operator: string,
            from: string,
            tokenId: BigNumberish,
            data: BytesLike,
            overrides?: CallOverrides
        ): Promise<string>;
    };

    filters: {};

    estimateGas: {
        onERC721Received(
            operator: string,
            from: string,
            tokenId: BigNumberish,
            data: BytesLike,
            overrides?: Overrides & { from?: string | Promise<string> }
        ): Promise<BigNumber>;
    };

    populateTransaction: {
        onERC721Received(
            operator: string,
            from: string,
            tokenId: BigNumberish,
            data: BytesLike,
            overrides?: Overrides & { from?: string | Promise<string> }
        ): Promise<PopulatedTransaction>;
    };
}
