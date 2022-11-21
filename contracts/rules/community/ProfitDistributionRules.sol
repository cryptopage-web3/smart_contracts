// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/IProfitDistributionRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.ProfitDistributionRules
/// @notice This contract contains rules.
/// @dev .
contract ProfitDistributionRules is IProfitDistributionRules, OwnableUpgradeable {

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2;//this is a temporary value, then it will need to be changed

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
                IRule(registry.rule()).isSupportedRule(RulesList.PROFIT_DISTRIBUTION_RULES, ruleName, communityId),
                "ProfitDistributionRules: this rule is not supported"
        );
        if (ruleName == RulesList.DISTRIBUTION_FOR_EVERYONE) {
            // there will be some logic here
        }
        if (ruleName == RulesList.DISTRIBUTION_USING_BADGE_TOKENS) {
            require(
                badge.balanceOf(user, badgeAllowId) > 0,
                "ProfitDistributionRules: you do not have enough Badge tokens"
            );
        }
        if (ruleName == RulesList.DISTRIBUTION_USING_VOTING) {
            // Sending profit to a special wallet
        }
        if (ruleName == RulesList.DISTRIBUTION_FOR_FOUNDERS) {
            // Logic for finding founders
            //and sending profits
        }
    }
}
