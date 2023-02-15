// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
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
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

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
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "ProfitDistributionRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_FOR_EVERYONE)) {
            return true;
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_USING_SOULBOUND_TOKENS)) {
            require(
                soulBound.balanceOf(_user, soulBoundAllowId) > 0,
                "ProfitDistributionRules: you do not have enough SoulBound tokens"
            );
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_USING_VOTING)) {
            require(registry.isVotingContract(_user), "ProfitDistributionRules: wrong voting contract");
            return true;
        }
        if (isActiveRule(_communityId, RulesList.DISTRIBUTION_FOR_FOUNDERS)) {
            require(ICommunityBlank(_communityId).creator() == _user, "ProfitDistributionRules: wrong founder");
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
