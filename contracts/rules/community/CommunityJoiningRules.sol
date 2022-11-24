// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/ICommunityJoiningRules.sol";


/// @title Contract of Page.CommunityJoiningRules
/// @notice This contract contains rules.
/// @dev .
contract CommunityJoiningRules is ICommunityJoiningRules {

    uint256 private constant RULES_VERSION = 1;
    bytes32 private GROUP_RULE = RulesList.COMMUNITY_JOINING_RULES;

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2;

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address badgeContract = registry.badge();
        require(badgeContract != address(0), "CommunityJoiningRules: address can't be zero");
        badge = IBadge(badgeContract);
    }

    function validate(address _communityId, address _user) external view override returns(bool) {
        if (isActiveRule(_communityId, RulesList.OPEN_TO_ALL)) {
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.BADGE_TOKENS_USING)) {
            require(
                badge.balanceOf(_user, badgeAllowId) > 0,
                "CommunityJoiningRules: you do not have enough Badge tokens"
            );
        }
        if (isActiveRule(_communityId, RulesList.WHEN_JOINING_PAYMENT)) {
            // check payment balance of user
        }
        if (isActiveRule(_communityId, RulesList.PERIODIC_PAYMENT)) {
            // check periodic payment balance of user
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
