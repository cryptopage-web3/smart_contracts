// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
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
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

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
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "CommunityEditModeratorsRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.NO_EDIT_MODERATOR)) {
            return false;
        }
        if (isActiveRule(_communityId, RulesList.EDIT_AFTER_VOTED)) {
            require(registry.isVotingContract(_user), "CommunityEditModeratorsRules: wrong voting contract");
            return true;
        }
        if (isActiveRule(_communityId, RulesList.EDIT_ONLY_SUPER_ADMIN)) {
            require(_user == registry.superAdmin(), "CommunityEditModeratorsRules: user is not super admin");
            return true;
        }
        if (isActiveRule(_communityId, RulesList.EDIT_BY_CREATOR)) {
            address currentOwner = Ownable(_communityId).owner();
            require(currentOwner == _user, "CommunityEditModeratorsRules: wrong owner for post");
            return true;
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
