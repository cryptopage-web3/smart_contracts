// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../plugins/PluginsList.sol";
import "./interfaces/IAccount.sol";
import "../registry/interfaces/IRegistry.sol";
import "../community/interfaces/ICommunityData.sol";

/// @title Contract of Page.Account
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Account is
    Initializable,
    AccessControlUpgradeable,
    IAccount
{
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    IRegistry public registry;

    struct CommunityUsers {
        EnumerableSetUpgradeable.AddressSet users;
        EnumerableSetUpgradeable.AddressSet moderators;
        EnumerableSetUpgradeable.AddressSet bannedUsers;
    }

    // communityId -> users
    mapping(address => CommunityUsers) private communityUsers;

    // communityId -> user -> postIds
    mapping(address => mapping(address => EnumerableSetUpgradeable.UintSet)) private createdPostIdsByUser;

    // communityId -> user -> postId -> commentIds
    mapping(address => mapping(address => mapping(uint256 => EnumerableSetUpgradeable.UintSet))) private createdCommentIdsByUser;

    event AddCommunityUser(bytes32 executedId, address indexed communityId, address user);
    event RemoveCommunityUser(bytes32 executedId, address indexed communityId, address user);
    event AddCommunityModerator(bytes32 executedId, address indexed communityId, address user);
    event RemoveCommunityModerator(bytes32 executedId, address indexed communityId, address user);
    event AddCreatedPostIdForUser(bytes32 executedId, address indexed communityId, address user, uint256 postId);
    event AddCreatedCommentIdForUser(
        bytes32 executedId,
        address indexed communityId,
        address user,
        uint256 postId,
        uint256 commentId
    );

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Account: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "Account: caller is not the plugin"
        );
        _;
    }

    function initialize(address _registry)
        external
        initializer
    {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function addCommunityUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_JOIN, _pluginName, _version) returns(bool) {
        require(_communityId != address(0) , "Account: address is zero");
        CommunityUsers storage users = communityUsers[_communityId];
        emit AddCommunityUser(_executedId, _communityId, _user);
        return users.users.add(_user);
    }

    function removeCommunityUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_QUIT, _pluginName, _version) returns(bool) {
        CommunityUsers storage users = communityUsers[_communityId];
        emit RemoveCommunityUser(_executedId, _communityId, _user);
        return users.users.remove(_user);
    }

    function addModerator(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_EDIT_MODERATORS, _pluginName, _version) returns(bool) {
        require(_communityId != address(0) , "Account: address is zero");
        CommunityUsers storage users = communityUsers[_communityId];
        emit AddCommunityModerator(_executedId, _communityId, _user);
        return users.moderators.add(_user);
    }

    function removeModerator(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_EDIT_MODERATORS, _pluginName, _version) returns(bool) {
        require(_communityId != address(0) , "Account: address is zero");
        CommunityUsers storage users = communityUsers[_communityId];
        emit RemoveCommunityModerator(_executedId, _communityId, _user);
        return users.moderators.remove(_user);
    }

    function addCreatedPostIdForUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user,
        uint256 _postId
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_POST, _pluginName, _version) returns(bool) {
        require(isCommunityUser(_communityId, _user), "Account: wrong community user");
        emit AddCreatedPostIdForUser(_executedId, _communityId, _user, _postId);

        return createdPostIdsByUser[_communityId][_user].add(_postId);
    }

    function addCreatedCommentIdForUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user,
        uint256 _postId,
        uint256 _commentId
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, _pluginName, _version) returns(bool) {
        require(isCommunityUser(_communityId, _user), "Account: wrong community user");
        require(ICommunityData(registry.communityData()).isLegalPostId(_communityId, _postId), "Account: wrong postId");
        emit AddCreatedCommentIdForUser(_executedId, _communityId, _user, _postId, _commentId);

        return createdCommentIdsByUser[_communityId][_user][_postId].add(_commentId);
    }

    function getCommunityCounts(address _communityId) external override view returns(
        uint256 normalUsers,
        uint256 bannedUsers,
        uint256 moderatorsUsers
    ) {
        CommunityUsers storage users = communityUsers[_communityId];
        normalUsers = users.users.length();
        bannedUsers = users.bannedUsers.length();
        moderatorsUsers = users.moderators.length();
    }

    function isCommunityUser(address _communityId, address _user) public override view returns(bool) {
        return communityUsers[_communityId].users.contains(_user);
    }

    function isBannedUser(address _communityId, address _user) external override view returns(bool) {
        return communityUsers[_communityId].bannedUsers.contains(_user);
    }

    function isModerator(address _communityId, address _user) external override view returns(bool) {
        return communityUsers[_communityId].moderators.contains(_user);
    }
}
