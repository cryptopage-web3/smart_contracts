// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/ICommunityJoiningRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.CommunityJoiningRules
/// @notice This contract contains rules.
/// @dev .
contract CommunityJoiningRules is ICommunityJoiningRules, OwnableUpgradeable {

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
                IRule(registry.rule()).isSupportedRule(RulesList.COMMUNITY_JOINING_RULES, ruleName, communityId),
                "CommunityJoiningRules: this rule is not supported"
        );
        if (ruleName == RulesList.OPEN_TO_ALL) {
            // there will be some logic here
        }
        if (ruleName == RulesList.BADGE_TOKENS_USING) {
            require(
                badge.balanceOf(user, badgeAllowId) > 0,
                "CommunityJoiningRules: you do not have enough Badge tokens"
            );
        }
        if (ruleName == RulesList.WHEN_JOINING_PAYMENT) {
            // check payment balance of user
        }
        if (ruleName == RulesList.PERIODIC_PAYMENT) {
            // check periodic payment balance of user
        }
    }
}
