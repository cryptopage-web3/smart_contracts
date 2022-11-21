// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/IPostPlacingRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.PostPlacingRules
/// @notice This contract contains rules.
/// @dev .
contract PostPlacingRules is IPostPlacingRules, OwnableUpgradeable {

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2;

    function version() external pure returns (string memory) {
        return "1";
    }

    function initialize(address _registry, address _badge) external initializer {
        __Ownable_init();
        registry = IRegistry(_registry);
        badge = IBadge(_badge);
    }

    function validate(address communityId, bytes32 ruleName, address user) external view override {
        require(
                IRule(registry.rule()).isSupportedRule(RulesList.POST_PLACING_RULES, ruleName, communityId),
                "PostPlacingRules: this rule is not supported"
        );
        if (ruleName == RulesList.FREE_FOR_EVERYONE) {
            require(user != address(0), "PostPlacingRules: user address is zero");
            // there will be some logic here
        }
        if (ruleName == RulesList.PAYMENT_FROM_EVERYONE) {
            // check payment balance of user
            // receiving payment
        }
        if (ruleName == RulesList.COMMUNITY_MEMBERS_ONLY) {
            // checking that the user is a member of the community
        }
        if (ruleName == RulesList.COMMUNITY_FOUNDERS_ONLY) {
            // checking that the user is a community founder
        }
    }
}
