// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../plugins/PluginsList.sol";
import "./interfaces/IAccount.sol";
import "../registry/interfaces/IRegistry.sol";

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

    event AddCommunityUser(bytes32 executedId, address indexed communityId, address user);
    event RemoveCommunityUser(bytes32 executedId, address indexed communityId, address user);
    event AddCreatedPostIdForUser(bytes32 executedId, address indexed communityId, address user, uint256 postId);

    modifier onlyJoinPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_JOIN, "Account: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "Account: caller is not the plugin"
        );
        _;
    }

    modifier onlyQuitPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_QUIT, "Account: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "Account: caller is not the plugin"
        );
        _;
    }

    modifier onlyWritePostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_WRITE_POST, "Account: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
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
    ) external override onlyJoinPlugin(_pluginName, _version) returns(bool) {
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
    ) external override onlyQuitPlugin(_pluginName, _version) returns(bool) {
        CommunityUsers storage users = communityUsers[_communityId];
        emit RemoveCommunityUser(_executedId, _communityId, _user);
        return users.users.remove(_user);
    }

    function addCreatedPostIdForUser(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _communityId,
        address _user,
        uint256 _postId
    ) external override onlyWritePostPlugin(_pluginName, _version) returns(bool) {
        require(_communityId != address(0) , "Account: address is zero");
        require(isCommunityUser(_communityId, _user), "Account: wrong community user");
        emit AddCreatedPostIdForUser(_executedId, _communityId, _user, _postId);

        return createdPostIdsByUser[_communityId][_user].add(_postId);
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
