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

import "./interfaces/ICommunityJoiningRules.sol";


/// @title Contract of Page.CommunityJoiningRules
/// @notice This contract contains rules.
/// @dev .
contract CommunityJoiningRules is ICommunityJoiningRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.COMMUNITY_JOINING_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_JOIN, RULES_VERSION) == _msgSender(),
            "CommunityJoiningRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "CommunityJoiningRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.OPEN_TO_ALL)) {
            return true;
        }
        if (isActiveRule(_communityId, RulesList.SOULBOUND_TOKENS_USING)) {
            require(
                soulBound.balanceOf(_user, soulBoundAllowId) > 0,
                "CommunityJoiningRules: you do not have enough SoulBound tokens"
            );
        }
        if (isActiveRule(_communityId, RulesList.WHEN_JOINING_PAYMENT)) {
            if (!IAccount(registry.account()).isCommunityUser(_communityId, _user)) {
                //Receiving payment from the user
            }
        }
        if (isActiveRule(_communityId, RulesList.PERIODIC_PAYMENT)) {
            if (IAccount(registry.account()).isCommunityUser(_communityId, _user)) {
                //Receiving payment from the user
            }
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
