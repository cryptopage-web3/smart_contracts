// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../plugins/PluginsList.sol";
import "./interfaces/IAccount.sol";
import "../registry/interfaces/IRegistry.sol";
import "../community/interfaces/ICommunityData.sol";
import "../community/interfaces/ICommentData.sol";
import "../libraries/DataTypes.sol";

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

    struct RedeemedCount {
        uint256[3] messageCount;
        uint256[3] postCount;
        uint256[2] upCount;
        uint256[2] downCount;
    }

    // communityId -> users
    mapping(address => CommunityUsers) private communityUsers;

    // user -> communities
    mapping(address => EnumerableSetUpgradeable.AddressSet) private communitiesByUser;

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
        require(communitiesByUser[_user].add(_communityId) , "Account: the user is already in the community");
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
        require(communitiesByUser[_user].remove(_communityId) , "Account: the user is no longer in the community");
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
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, vars.pluginName, vars.version) returns(bool) {
        (address _communityId, uint256 _postId, uint256 _commentId) = abi.decode(vars.data,(address,uint256,uint256));

        require(isCommunityUser(_communityId, vars.user), "Account: wrong community user");
        require(ICommunityData(registry.communityData()).isLegalPostId(_communityId, _postId), "Account: wrong postId");
        emit AddCreatedCommentIdForUser(vars.executedId, _communityId, vars.user, _postId, _commentId);

        return createdCommentIdsByUser[_communityId][vars.user][_postId].add(_commentId);
    }

    function getCommunityUsersCounts(address _communityId) external override view returns(
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

    function getCommunityUsers(address _communityId) external override view returns(
        address[] memory normalUsers,
        address[] memory bannedUsers,
        address[] memory moderators
    ) {
        CommunityUsers storage users = communityUsers[_communityId];
        normalUsers = users.users.values();
        bannedUsers = users.bannedUsers.values();
        moderators = users.moderators.values();
    }

    function getCommunitiesByUser(address _user) public override view returns(
        address[] memory _communities
    ) {
        _communities = communitiesByUser[_user].values();
    }

    function getPostIdsByUserAndCommunity(address _communityId, address _user) public override view returns(
        uint256[] memory _postIds
    ) {
        _postIds = createdPostIdsByUser[_communityId][_user].values();
    }

    function getAllPostIdsByUser(address _user) public override view returns(
        uint256[] memory
    ) {
        DataTypes.UserRateCount memory rate = getAllCommunitiesUserRate(_user);
        address[] memory communities = getCommunitiesByUser(_user);

        uint256 count = rate.postCount;
        uint256[] memory postIds = new uint256[](count);

        if (count > 0) {
            for(uint256 i=0; i < communities.length; i++) {
                uint256[] memory tempIds = getPostIdsByUserAndCommunity(communities[i], _user);
                for(uint256 j=0; j < tempIds.length; j++) {
                    count--;
                    postIds[count] = tempIds[j];
                }
            }
        }

        return postIds;
    }

    function getCommentIdsByUserAndPost(
        address _communityId,
        address _user,
        uint256 _postId
    ) public override view returns(uint256[] memory _commentIds) {
        _commentIds = createdCommentIdsByUser[_communityId][_user][_postId].values();
    }

    function getUserRate(
        address _user,
        address _communityId
    ) public override view returns(DataTypes.UserRateCount memory _counts) {
        uint256[] memory postIds = getPostIdsByUserAndCommunity(_communityId, _user);
        _counts.postCount += postIds.length;
        for(uint256 j=0; j < postIds.length; j++) {
            uint256 postId = postIds[j];
            uint256[] memory commentIds = getCommentIdsByUserAndPost(_communityId, _user, postId);
            _counts.commentCount += commentIds.length;
            for(uint256 k=0; k < commentIds.length; k++) {
                uint256 commentId = commentIds[k];
                (bool isUp, bool isDown) = ICommentData(registry.commentData()).getUpDownForComment(
                    postId,
                    commentId
                );
                if (isUp) {
                    _counts.upCount++;
                }
                if (isDown) {
                    _counts.downCount++;
                }
            }
        }
    }

    function getAllCommunitiesUserRate(
        address _user
    ) public override view returns(DataTypes.UserRateCount memory _counts) {
        address[] memory communities = communitiesByUser[_user].values();

        for(uint256 i=0; i < communities.length; i++) {
            address communityId = communities[i];
            DataTypes.UserRateCount memory communityCounts = getUserRate(_user, communityId);
            _counts.postCount += communityCounts.postCount;
            _counts.commentCount += communityCounts.commentCount;
            _counts.upCount += communityCounts.upCount;
            _counts.downCount += communityCounts.downCount;
        }
    }
}
