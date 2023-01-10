// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../libraries/DataTypes.sol";


interface IAccount {
    function version() external pure returns (string memory);

    function addCommunityUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function removeCommunityUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function addModerator(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function removeModerator(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function addCreatedPostIdForUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user,
        uint256 _postId
    ) external returns(bool);

    function addCreatedCommentIdForUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user,
        uint256 _postId,
        uint256 _commentId
    ) external returns(bool);

    function getCommunityUsersCounts(address _communityId) external view returns(
        uint256 normalUsers,
        uint256 bannedUsers,
        uint256 moderatorsUsers
    );

    function getCommunityUsers(address _communityId) external view returns(
        address[] memory normalUsers,
        address[] memory bannedUsers,
        address[] memory moderators
    );

    function isCommunityUser(address _communityId, address _user) external view returns(bool);

    function isBannedUser(address _communityId, address _user) external view returns(bool);

    function isModerator(address _communityId, address _user) external view returns(bool);

    function getCommunitiesByUser(address _user) external view returns(
        address[] memory _communities
    );

    function getPostIdsByUser(address _communityId, address _user) external view returns(
        uint256[] memory _postIds
    );

    function getCommentIdsByUserAndPost(
        address _communityId,
        address _user,
        uint256 _postId
    ) external view returns(uint256[] memory _commentIds);

    function getUserRate(
        address _user
    ) external view returns(DataTypes.UserRateCount memory _counts);
}
