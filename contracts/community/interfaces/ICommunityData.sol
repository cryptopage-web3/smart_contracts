// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../libraries/DataTypes.sol";


interface ICommunityData {

    function version() external pure returns (string memory);

    function isCommunity(address _community) external view returns (bool);

    function addCommunity(
        DataTypes.SimpleVars calldata vars
    ) external returns (bool);

    function addCreatedPostIdForCommunity(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function getCommunities(uint256 _startIndex, uint256 _endIndex) external view returns (address[] memory result);

    function communitiesCount() external view returns (uint256);

    function isLegalPostId(address _community, uint256 _postId) external view returns (bool);

    function getPostIds(address _community) external view returns (uint[] memory);
}
