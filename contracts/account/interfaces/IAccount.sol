// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IAccount {
    function version() external pure returns (string memory);

//    function setPluginDirect(address account, uint16 typeId, uint16 pluginId) external;
//
//    function setPlugin(address publisher, string memory typeName, string memory pluginName) external;
//
//    function getPlugin(address publisher, uint16 typeId) external view returns (uint16);

}
