// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ICommunityData {

    function version() external pure returns (string memory);

    function isCommunity(address community) external view returns (bool);

    function addCommunity(bytes32 pluginName, uint256 version, address communityId) external returns (bool);

}
