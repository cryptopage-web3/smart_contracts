// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IReputationManagementRules.sol";


/// @title Contract of Page.ReputationManagementRules
/// @notice This contract contains rules.
/// @dev .
contract ReputationManagementRules is IReputationManagementRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.REPUTATION_MANAGEMENT_RULES;
    uint256 public constant soulBoundAllowId = 2;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugin() {
        require(
        // COMMUNITY_TRANSFER_POST is temporary
            registry.getPluginContract(PluginsList.COMMUNITY_TRANSFER_POST, RULES_VERSION) == _msgSender(),
            "ReputationManagementRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "ReputationManagementRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(address _communityId, address _user) external view override onlyPlugin returns(bool) {
        if (isActiveRule(_communityId, RulesList.REPUTATION_NOT_USED)) {
            // there will be some logic here
        }
        if (isActiveRule(_communityId, RulesList.REPUTATION_CAN_CHANGE)) {
            require(
                soulBound.balanceOf(_user, soulBoundAllowId) > 0,
                "ReputationManagementRules: you do not have enough SoulBound tokens"
            );
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
