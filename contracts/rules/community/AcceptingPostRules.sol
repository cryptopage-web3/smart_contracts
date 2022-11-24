// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IAcceptingPostRules.sol";


/// @title Contract of Page.AcceptingPostRules
/// @notice This contract contains rules.
/// @dev .
contract AcceptingPostRules is IAcceptingPostRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.ACCEPTING_POST_RULES;
    uint256 public constant badgeAllowId = 2;

    IRegistry public registry;
    IBadge public badge;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_TRANSFER_POST, RULES_VERSION) == _msgSender(),
            "AcceptingPostRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address badgeContract = registry.badge();
        require(badgeContract != address(0), "CommunityJoiningRules: address can't be zero");
        badge = IBadge(badgeContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.ACCEPTING_FOR_EVERYONE)) {
            require(_user != address(0), "AcceptingPostRules: user address is zero");
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.ACCEPTING_FOR_COMMUNITY_MEMBERS_ONLY)) {
            // checking that the user is a member of the community
        }
        if (isActiveRule(_communityId, RulesList.ACCEPTING_AFTER_MODERATOR_APPROVED)) {
            // moderator approval check
        }
        if (isActiveRule(_communityId, RulesList.ACCEPTING_FOR_COMMUNITY_FOUNDERS_ONLY)) {
            // checking that the user is a community founder
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
