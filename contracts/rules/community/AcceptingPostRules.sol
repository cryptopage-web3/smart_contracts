// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../badge/interfaces/IBadge.sol";
import "./interfaces/IAcceptingPostRules.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";


/// @title Contract of Page.AcceptingPostRules
/// @notice This contract contains rules.
/// @dev .
contract AcceptingPostRules is IAcceptingPostRules, OwnableUpgradeable {

    IRegistry registry;
    IBadge badge;
    uint256 constant badgeAllowId = 2;

    function version() external pure returns (string memory) {
        return "1";
    }

    function initialize(address _registry, address _badge) external initializer {
        __Ownable_init();
        registry = IRegistry(_registry);
        badge = IBadge(_badge);
    }

    function validate(address communityId, bytes32 ruleName, address user) external view override {
        require(
                IRule(registry.rule()).isSupportedRule(RulesList.ACCEPTING_POST_RULES, ruleName, communityId),
                "AcceptingPostRules: this rule is not supported"
        );
        if (ruleName == RulesList.ACCEPTING_FOR_EVERYONE) {
            require(user != address(0), "AcceptingPostRules: user address is zero");
            // there will be some logic here
        }
        if (ruleName == RulesList.ACCEPTING_FOR_COMMUNITY_MEMBERS_ONLY) {
            // checking that the user is a member of the community
        }
        if (ruleName == RulesList.ACCEPTING_AFTER_MODERATOR_APPROVED) {
            // moderator approval check
        }
        if (ruleName == RulesList.ACCEPTING_FOR_COMMUNITY_FOUNDERS_ONLY) {
            // checking that the user is a community founder
        }
    }
}
