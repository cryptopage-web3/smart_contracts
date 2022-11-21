// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ICommunityData {

    function version() external pure returns (string memory);

    function isCommunity(address _community) external view returns (bool);

    function addCommunity(bytes32 _pluginName, uint256 _version, address _communityId) external returns (bool);

    function getCommunities(uint256 _startIndex, uint256 _endIndex) external view returns (address[] memory result);

    function communitiesCount() external view returns (uint256);
}
