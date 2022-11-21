// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "./interfaces/IPostTransferringRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.PostTransferringRules
/// @notice This contract contains rules.
/// @dev .
contract PostTransferringRules is IPostTransferringRules, OwnableUpgradeable {

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
                IRule(registry.rule()).isSupportedRule(RulesList.POST_TRANSFERRING_RULES, ruleName, communityId),
                "PostTransferringRules: this rule is not supported"
        );
        if (ruleName == RulesList.TRANSFERRING_DENIED) {
            // there will be some logic here
        }
        if (ruleName == RulesList.TRANSFERRING_WITH_VOTING) {
            // here is the logic for transferring tokens to community
        }
        if (ruleName == RulesList.TRANSFERRING_ONLY_AUTHOR) {
            require(user != address(0), "PostTransferringRules: user address is zero");
            // some logic for this user
        }
    }
}
