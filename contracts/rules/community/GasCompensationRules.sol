// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../plugins/PluginsList.sol";
import "../interfaces/IRule.sol";
import "./RulesList.sol";

import "./interfaces/IGasCompensationRules.sol";

/// @title Contract of Page.GasCompenstionRules
/// @notice This contract contains rules.
/// @dev .
contract GasCompensationRules is IGasCompensationRules, Context {

    uint256 public constant RULES_VERSION = 1;
    bytes32 public GROUP_RULE = RulesList.GAS_COMPENSATION_RULES;
    address public constant EMPTY_ADDRESS = address(0);

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyPlugins() {
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_WRITE_POST, RULES_VERSION) == _msgSender()
            || registry.getPluginContract(PluginsList.COMMUNITY_WRITE_COMMENT, RULES_VERSION) == _msgSender(),
            "GasCompenstionRules: caller is not the plugin");
        _;
    }

    function version() external pure returns (uint256) {
        return RULES_VERSION;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        address soulBoundContract = registry.soulBound();
        require(soulBoundContract != address(0), "GasCompenstionRules: address can't be zero");
        soulBound = ISoulBound(soulBoundContract);
    }

    function validate(
        address _communityId,
        address _author,
        address _owner
    ) external view override onlyPlugins returns(address[] memory) {
        address[] memory users = new address[](2);
        if (isActiveRule(_communityId, RulesList.NO_GAS_COMPENSATION)) {
            return users;
        }
        if (isActiveRule(_communityId, RulesList.GAS_COMPENSATION_FOR_COMMUNITY)) {
            users[0] = _communityId;
            return users;
        }
        if (isActiveRule(_communityId, RulesList.GAS_COMPENSATION_FOR_AUTHOR)) {
            users[0] = _author;
            return users;
        }
        if (isActiveRule(_communityId, RulesList.GAS_COMPENSATION_FOR_OWNER)) {
            users[0] = _owner;
            return users;
        }
        if (isActiveRule(_communityId, RulesList.GAS_COMPENSATION_FOR_AUTHOR_AND_OWNER)) {
            users[0] = _author;
            users[0] = _owner;
        }
        return users;
    }

    function isActiveRule(address _communityId, bytes32 _ruleName) private view returns(bool) {
        return (
        ICommunityBlank(_communityId).isLinkedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        && IRule(registry.rule()).isSupportedRule(GROUP_RULE, RULES_VERSION, _ruleName)
        );
    }
}
