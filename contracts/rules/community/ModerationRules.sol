// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../account/interfaces/IAccount.sol";
import "../../tokens/nft/interfaces/INFT.sol";
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
            registry.getPluginContract(PluginsList.COMMUNITY_WRITE_POST, RULES_VERSION) == _msgSender()
            || registry.getPluginContract(PluginsList.COMMUNITY_BURN_POST, RULES_VERSION) == _msgSender()
            || registry.getPluginContract(PluginsList.COMMUNITY_BURN_COMMENT, RULES_VERSION) == _msgSender(),
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

    function validate(address _communityId, address _moderator, uint256 _postId) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.NO_MODERATOR)) {
            return false;
        }
        if (isActiveRule(_communityId, RulesList.MODERATION_USING_OWNER)) {
            address currentOwner = INFT(registry.nft()).ownerOf(_postId);
            require(currentOwner == _moderator, "ModerationRules: wrong owner for post");
            return true;
        }
        if (isActiveRule(_communityId, RulesList.MODERATION_USING_VOTING)) {
            require(registry.isVotingContract(_moderator), "ModerationRules: wrong voting contract");
            return true;
        }
        if (isActiveRule(_communityId, RulesList.MODERATION_USING_MODERATORS)) {
            require(IAccount(registry.account()).isModerator(_communityId, _moderator), "ModerationRules: wrong moderator");
            return true;
        }

        return false;
    }

    function isActiveRule(address _communityId, bytes32 _ruleName) private view returns(bool) {
        return (
        ICommunityBlank(_communityId).isLinkedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        && IRule(registry.rule()).isSupportedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        );
    }
}
