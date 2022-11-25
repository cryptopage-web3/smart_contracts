// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IPlugin {

    function execute(bytes32 executedId, uint256 version, address sender, bytes calldata data) external;

}
