// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IReadPlugin {

    function read(uint256 version, address sender, bytes calldata data) external returns(bytes memory);

}
