// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IPostCommentingRules.sol";


/// @title Contract of Page.PostCommentingRules
/// @notice This contract contains rules.
/// @dev .
contract PostCommentingRules is IPostCommentingRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.POST_COMMENTING_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_WRITE_COMMENT, RULES_VERSION) == _msgSender()
            || registry.getPluginContract(PluginsList.COMMUNITY_READ_COMMENT, RULES_VERSION) == _msgSender(),
            "PostCommentingRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "PostCommentingRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.COMMENTING_MANY_TIMES)) {
            require(_user != address(0), "PostCommentingRules: user address is zero");
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.COMMENTING_ONE_TIME)) {
            // check previous comments from this user
        }
        if (isActiveRule(_communityId, RulesList.COMMENTING_WITH_SOULBOUND_TOKENS)) {
            require(
                soulBound.balanceOf(_user, soulBoundAllowId) > 0,
                "PostCommentingRules: you do not have enough SoulBound tokens"
            );
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
