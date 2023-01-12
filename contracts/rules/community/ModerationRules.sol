// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IModerationRules.sol";

/// @title Contract of Page.ModerationRules
/// @notice This contract contains rules.
/// @dev .
contract ModerationRules is IModerationRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.MODERATION_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_WRITE_POST, RULES_VERSION) == _msgSender(),
            "ModerationRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "ModerationRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.NO_MODERATION)) {
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.MODERATION_USING_VOTING)) {
            // here is the logic for voting
        }
        if (isActiveRule(_communityId, RulesList.MODERATION_USING_MODERATORS)) {
            require(_user != address(0), "ModerationRules: user address is zero");
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
