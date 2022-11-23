// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/ICommunityData.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";

/// @title Contract of Page.CommunityData
/// @author Crypto.Page Team
/// @notice
/// @dev
contract CommunityData is
    Initializable,
    AccessControlUpgradeable,
    ICommunityData
{
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER_ROLE");

    IRegistry public registry;

    EnumerableSetUpgradeable.AddressSet private communities;

    event AddedCommunity(address indexed sender, address communityId, uint256 timestamp);

    modifier onlyCreatePlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_CREATE, "CommunityData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
                "CommunityData: caller is not the plugin"
        );
        _;
    }

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    //constructor() initializer {}

    function initialize(address _registry)
        external
        initializer
    {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function addCommunity(
        bytes32 _pluginName,
        uint256 _version,
        address _communityId
    ) external override onlyCreatePlugin(_pluginName, _version) returns(bool result) {
        require(_communityId != address(0) , "Community: wrong communityId");
        result = communities.add(_communityId);

        emit AddedCommunity(_msgSender(), _communityId, block.timestamp);
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
}