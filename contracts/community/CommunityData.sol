// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/ICommunityData.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";

/// @title Contract of Page.CommunityData
/// @author Crypto.Page Team
/// @notice
/// @dev
contract CommunityData is Initializable, ContextUpgradeable, ICommunityData {

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    IRegistry public registry;

    EnumerableSetUpgradeable.AddressSet private communities;

    // communityId -> postIds
    mapping(address => EnumerableSetUpgradeable.UintSet) private postIdsByCommunity;


    event AddedCommunity(bytes32 executedId, address indexed sender, address communityId, uint256 timestamp);
    event AddPostIdForCommunity(bytes32 executedId, address indexed communityId, uint256 postId);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "CommunityData: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "CommunityData: caller is not the plugin"
        );
        _;
    }

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    //constructor() initializer {}

    function initialize(address _registry) external initializer {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function addCommunity(
        DataTypes.SimpleVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_CREATE, vars.pluginName, vars.version) returns(bool result) {
        (address _communityId) = abi.decode(vars.data,(address));
        require(_communityId != address(0) , "Community: wrong communityId");
        result = communities.add(_communityId);

        emit AddedCommunity(vars.executedId, _msgSender(), _communityId, block.timestamp);
    }

    function addCreatedPostIdForCommunity(
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_POST, vars.pluginName, vars.version) returns(bool) {
        (address _communityId, uint256 _postId) = abi.decode(vars.data,(address, uint256));

        require(_communityId != address(0) , "CommunityData: address is zero");
        emit AddPostIdForCommunity(vars.executedId, _communityId, _postId);

        return postIdsByCommunity[_communityId].add(_postId);
    }

    function isCommunity(address _community) external view returns (bool) {
        return communities.contains(_community);
    }

    function getCommunities(uint256 _startIndex, uint256 _endIndex) external override view returns (address[] memory result) {
        require(_startIndex <= _endIndex , "Community: wrong index");
        require(_endIndex < communities.length(), "Community: wrong index");
        uint256 count = _endIndex - _startIndex + 1;
        result = new address[](count);
        for(uint256 i = 0; i < count; i++) {
            result[i] = communities.at(_startIndex + i);
        }
    }

    function communitiesCount() external override view returns (uint256) {
        return communities.length();
    }

    function isLegalPostId(address _community, uint256 _postId) external override view returns (bool) {
        return postIdsByCommunity[_community].contains(_postId);
    }

    function getPostIds(address _community) external override view returns (uint[] memory) {
        return postIdsByCommunity[_community].values();
    }
}
