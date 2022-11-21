// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "./interfaces/IGasCompenstionRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.GasCompenstionRules
/// @notice This contract contains rules.
/// @dev .
contract GasCompenstionRules is IGasCompenstionRules, OwnableUpgradeable {

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
                IRule(registry.rule()).isSupportedRule(RulesList.GAS_COMPENSATION_RULES, ruleName, communityId),
                "GasCompenstionRules: this rule is not supported"
        );
        if (ruleName == RulesList.NO_GAS_COMPENSATION) {
            // there will be some logic here
        }
        if (ruleName == RulesList.GAS_COMPENSATION_FOR_COMMUNITY) {
            // here is the logic for transferring tokens to community
        }
        if (ruleName == RulesList.GAS_COMPENSATION_FOR_AUTHOR) {
            require(user != address(0), "GasCompenstionRules: user address is zero");
            // some logic for this user
        }
    }
}
