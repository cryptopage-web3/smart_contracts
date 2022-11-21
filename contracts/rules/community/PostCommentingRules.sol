// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/IPostCommentingRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.PostCommentingRules
/// @notice This contract contains rules.
/// @dev .
contract PostCommentingRules is IPostCommentingRules, OwnableUpgradeable {

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2; //this value is for example

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
                IRule(registry.rule()).isSupportedRule(RulesList.POST_COMMENTING_RULES, ruleName, communityId),
                "PostCommentingRules: this rule is not supported"
        );
        if (ruleName == RulesList.COMMENTING_MANY_TIMES) {
            require(user != address(0), "PostCommentingRules: user address is zero");
            // there will be some logic here
        }
        if (ruleName == RulesList.COMMENTING_ONE_TIME) {
            // check previous comments from this user
        }
        if (ruleName == RulesList.COMMENTING_WITH_BADGE_TOKENS) {
            require(
                badge.balanceOf(user, badgeAllowId) > 0,
                "PostCommentingRules: you do not have enough Badge tokens"
            );
            // some logic for this user
        }
    }
}
