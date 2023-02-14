// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../account/interfaces/IAccount.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IPostPlacingRules.sol";


/// @title Contract of Page.PostPlacingRules
/// @notice This contract contains rules.
/// @dev .
contract PostPlacingRules is IPostPlacingRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.POST_PLACING_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_WRITE_POST, RULES_VERSION) == _msgSender(),
            "PostPlacingRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "PostPlacingRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.FREE_FOR_EVERYONE)) {
            return true;
        }
        if (isActiveRule(_communityId, RulesList.PAYMENT_FROM_EVERYONE)) {
            // check payment balance of user
            // receiving payment
        }
        if (isActiveRule(_communityId, RulesList.COMMUNITY_MEMBERS_ONLY)) {
            require(IAccount(registry.account()).isCommunityUser(_communityId, _user), "PostPlacingRules: wrong user");
        }
        if (isActiveRule(_communityId, RulesList.COMMUNITY_FOUNDERS_ONLY)) {
            require(ICommunityBlank(_communityId).creator() == _user, "PostPlacingRules: wrong founder");
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
