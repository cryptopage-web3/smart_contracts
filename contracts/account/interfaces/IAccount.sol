// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../libraries/DataTypes.sol";


interface IAccount {
    function version() external pure returns (string memory);

    function addCommunityUser(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function removeCommunityUser(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function addModerator(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function removeModerator(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function addCreatedPostIdForUser(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function addCreatedCommentIdForUser(
        DataTypes.GeneralVars calldata vars
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

    function getPostIdsByUserAndCommunity(address _communityId, address _user) external view returns(
        uint256[] memory _withCommentPostIds,
        uint256[] memory _createdPostIds
    );

    function getAllPostIdsByUser(address _user) external view returns(uint256[] memory);

    function getCommentIdsByUserAndPost(
        address _communityId,
        address _user,
        uint256 _postId
    ) external view returns(uint256[] memory _commentIds);

    function getUserRate(
        address _user,
        address _communityId
    ) external view returns(DataTypes.UserRateCount memory _counts);

    function getAllCommunitiesUserRate(
        address _user
    ) external view returns(DataTypes.UserRateCount memory _counts);
}
