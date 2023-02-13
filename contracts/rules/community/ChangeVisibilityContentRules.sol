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

import "./interfaces/IChangeVisibilityContentRules.sol";


/// @title Contract of Page.ChangeVisibilityContentRules
/// @notice This contract contains rules.
/// @dev .
contract ChangeVisibilityContentRules is IChangeVisibilityContentRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.CHANGE_VISIBILITY_CONTENT_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_CHANGE_VISIBILITY_POST, RULES_VERSION) == _msgSender() ||
            registry.getPluginContract(PluginsList.COMMUNITY_CHANGE_VISIBILITY_COMMENT, RULES_VERSION) == _msgSender(),
            "ChangeVisibilityContentRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "ChangeVisibilityContentRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user, uint256 _postId) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.NO_CHANGE_VISIBILITY)) {
            return false;
        }
        if (isActiveRule(_communityId, RulesList.CHANGE_VISIBILITY_USING_VOTING)) {
            require(registry.isVotingContract(_user), "ChangeVisibilityContentRules: wrong voting contract");
        }
        if (isActiveRule(_communityId, RulesList.CHANGE_VISIBILITY_ONLY_MODERATORS)) {
            require(IAccount(registry.account()).isModerator(_communityId, _user), "ChangeVisibilityContentRules: wrong moderator");
        }
        if (isActiveRule(_communityId, RulesList.CHANGE_VISIBILITY_ONLY_OWNER)) {
            address currentOwner = INFT(registry.nft()).ownerOf(_postId);
            require(currentOwner == _user, "ChangeVisibilityContentRules: wrong owner for post");
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
