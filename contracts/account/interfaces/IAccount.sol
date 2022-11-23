// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IAccount {
    function version() external pure returns (string memory);

    function addCommunityUser(
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function removeCommunityUser(
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external returns(bool);

    function getCommunityCounts(address _communityId) external view returns(
        uint256 normalUsers,
        uint256 bannedUsers,
        uint256 moderatorsUsers
    );

    function isCommunityUser(address _communityId, address _user) external view returns(bool);

    function isBannedUser(address _communityId, address _user) external view returns(bool);

    function isModerator(address _communityId, address _user) external view returns(bool);

}
