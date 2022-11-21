// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "./interfaces/IAdvertisingPlacementRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.AdvertisingPlacementRules
/// @notice This contract contains rules.
/// @dev .
contract AdvertisingPlacementRules is IAdvertisingPlacementRules, OwnableUpgradeable {

    IRegistry registry;

    function version() external pure returns (string memory) {
        return "1";
    }

    function initialize(address _registry) external initializer {
        __Ownable_init();
        registry = IRegistry(_registry);
    }

    function validate(address communityId, bytes32 ruleName, address user) external view override {
        require(
                IRule(registry.rule()).isSupportedRule(RulesList.ADVERTISING_PLACEMENT_RULES, ruleName, communityId),
                "AdvertisingPlacementRules: this rule is not supported"
        );
        if (ruleName == RulesList.NO_ADVERTISING) {
            // there will be some logic here
        }
        if (ruleName == RulesList.ADVERTISING_BY_FOUNDERS) {
            // some logic for founders
        }
        if (ruleName == RulesList.ADVERTISING_BY_MODERATORS) {
            // some logic for moderators
        }
        if (ruleName == RulesList.ADVERTISING_BY_SPECIAL_USER) {
            require(user != address(0), "AdvertisingPlacementRules: user address is zero");
            // some logic for this user
        }
    }
}
