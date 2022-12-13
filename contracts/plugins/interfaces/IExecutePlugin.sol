// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IExecutePlugin {

    function execute(bytes32 executedId, uint256 version, address sender, bytes calldata data) external returns(bool);

}
