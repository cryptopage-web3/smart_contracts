// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "./interfaces/IModerationRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.ModerationRules
/// @notice This contract contains rules.
/// @dev .
contract ModerationRules is IModerationRules, OwnableUpgradeable {

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
                IRule(registry.rule()).isSupportedRule(RulesList.MODERATION_RULES, ruleName, communityId),
                "ModerationRules: this rule is not supported"
        );
        if (ruleName == RulesList.NO_MODERATION) {
            // there will be some logic here
        }
        if (ruleName == RulesList.MODERATION_USING_VOTING) {
            // here is the logic for voting
        }
        if (ruleName == RulesList.MODERATION_USING_MODERATORS) {
            require(user != address(0), "ModerationRules: user address is zero");
            // some logic for this user
        }
    }
}
