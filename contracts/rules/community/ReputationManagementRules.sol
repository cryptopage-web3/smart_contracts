// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/IReputationManagementRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.ReputationManagementRules
/// @notice This contract contains rules.
/// @dev .
contract ReputationManagementRules is IReputationManagementRules, OwnableUpgradeable {

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2; //this is a temporary value, then it will need to be changed

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
                IRule(registry.rule()).isSupportedRule(RulesList.REPUTATION_MANAGEMENT_RULES, ruleName, communityId),
                "ReputationManagementRules: this rule is not supported"
        );
        if (ruleName == RulesList.REPUTATION_NOT_USED) {
            // there will be some logic here
        }
        if (ruleName == RulesList.REPUTATION_CAN_CHANGE) {
            require(
                badge.balanceOf(user, badgeAllowId) > 0,
                "ReputationManagementRules: you do not have enough Badge tokens"
            );
        }
    }
}
