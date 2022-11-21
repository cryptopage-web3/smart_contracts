// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "./interfaces/IPostReadingRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.PostReadingRules
/// @notice This contract contains rules.
/// @dev .
contract PostReadingRules is IPostReadingRules, OwnableUpgradeable {

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
                IRule(registry.rule()).isSupportedRule(RulesList.POST_READING_RULES, ruleName, communityId),
                "PostReadingRules: this rule is not supported"
        );
        if (ruleName == RulesList.READING_FOR_EVERYONE) {
            require(user != address(0), "PostReadingRules: user address is zero");
            // there will be some logic here
        }
        if (ruleName == RulesList.READING_ENCRYPTED) {
            // status check that messages are encrypted
        }
    }
}
