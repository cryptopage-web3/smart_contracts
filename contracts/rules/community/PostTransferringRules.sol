// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../community/interfaces/IPostData.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IPostTransferringRules.sol";


/// @title Contract of Page.PostTransferringRules
/// @notice This contract contains rules.
/// @dev .
contract PostTransferringRules is IPostTransferringRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.POST_TRANSFERRING_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_REPOST, RULES_VERSION) == _msgSender(),
            "PostTransferringRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "PostTransferringRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user, uint256 _postId) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.TRANSFERRING_DENIED)) {
            return false;
        }
        if (isActiveRule(_communityId, RulesList.TRANSFERRING_WITH_VOTING)) {
            require(registry.isVotingContract(_user), "PostTransferringRules: wrong voting contract");
        }
        if (isActiveRule(_communityId, RulesList.TRANSFERRING_ONLY_AUTHOR)) {
            require(IPostData(registry.postData()).isCreator(_postId, _user), "PostTransferringRules: wrong author");
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
