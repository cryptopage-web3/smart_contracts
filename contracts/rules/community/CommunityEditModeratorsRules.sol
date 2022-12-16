// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/badge/interfaces/IBadge.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/ICommunityEditModeratorsRules.sol";

/// @title Contract of Page.CommunityEditModeratorsRules
/// @notice This contract contains rules.
/// @dev .
contract CommunityEditModeratorsRules is ICommunityEditModeratorsRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.COMMUNITY_EDIT_MODERATOR_RULES;
    uint256 public constant badgeAllowId = 2;

    IRegistry public registry;
    IBadge public badge;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_EDIT_MODERATORS, RULES_VERSION) == _msgSender(),
            "CommunityEditModeratorsRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address badgeContract = registry.badge();
        require(badgeContract != address(0), "CommunityEditModeratorsRules: address can't be zero");
        badge = IBadge(badgeContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.NO_EDIT_MODERATOR)) {
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.EDIT_AFTER_VOTED)) {
            // here is the logic for voting
        }
        if (isActiveRule(_communityId, RulesList.EDIT_ONLY_SUPER_ADMIN)) {
            require(_user != address(0), "CommunityEditModeratorsRules: user address is zero");
            // some logic for this user
        }
        if (isActiveRule(_communityId, RulesList.EDIT_BY_CREATOR)) {
            require(_user != address(0), "CommunityEditModeratorsRules: user address is zero");
            // some logic for this user
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