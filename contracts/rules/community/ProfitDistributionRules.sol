// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/badge/interfaces/IBadge.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IProfitDistributionRules.sol";


/// @title Contract of Page.ProfitDistributionRules
/// @notice This contract contains rules.
/// @dev .
contract ProfitDistributionRules is IProfitDistributionRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.PROFIT_DISTRIBUTION_RULES;
    uint256 public constant badgeAllowId = 2;

    IRegistry public registry;
    IBadge public badge;

    modifier onlyPlugin() {
        require(
        // COMMUNITY_TRANSFER_POST is temporary
            registry.getPluginContract(PluginsList.COMMUNITY_TRANSFER_POST, RULES_VERSION) == _msgSender(),
            "ProfitDistributionRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address badgeContract = registry.badge();
        require(badgeContract != address(0), "ProfitDistributionRules: address can't be zero");
        badge = IBadge(badgeContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_FOR_EVERYONE)) {
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_USING_BADGE_TOKENS)) {
            require(
                badge.balanceOf(_user, badgeAllowId) > 0,
                "ProfitDistributionRules: you do not have enough Badge tokens"
            );
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_USING_VOTING)) {
            // Sending profit to a special wallet
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_FOR_FOUNDERS)) {
            // Logic for finding founders
            //and sending profits
        }

        return true;
    }

    function isActiveRule(address _communityId, bytes32 _ruleName) private view returns(bool) {
        return (
        ICommunityBlank(_communityId).isLinkedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        && IRule(registry.rule()).isSupportedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        );
    }
}
