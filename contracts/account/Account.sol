// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/IAccount.sol";
import "../registry/interfaces/IRegistry.sol";

/// @title Contract of Page.Community
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Account is
    Initializable,
    AccessControlUpgradeable,
    IAccount
{
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    address public registry;

    struct CommunityUsers {
        EnumerableSetUpgradeable.AddressSet users;
        EnumerableSetUpgradeable.AddressSet moderators;
        EnumerableSetUpgradeable.AddressSet bannedUsers;
    }

    // communityId -> users
    mapping(address => CommunityUsers) private communityUsers;

    function initialize(address _registry)
        external
        initializer
    {
        registry = _registry;
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function addCommunityUser() external {

    }
}
