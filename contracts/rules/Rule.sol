// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/IRule.sol";


/// @title Contract of Page.Rule
/// @notice This contract is needed to manage the rules.
/// @dev There is logic here for adding, removing, enabling and disabling rules
contract Rule is OwnableUpgradeable, IRule {

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    bytes32 public constant EMPTY_NAME = bytes32(0);

    struct GroupRule {
        address ruleContract;
        mapping(bytes32 => bool) rules;
    }

    // groupRuleName -> version -> GroupRule
    mapping(bytes32 => mapping(uint256 => GroupRule)) private groupRules;

    event SetRuleContract(bytes32 ruleGroupName, uint256 version, address ruleContract);
    event EnableRule(bytes32 ruleGroupName, uint256 version, bytes32 ruleName);
    event DisableRule(bytes32 ruleGroupName, uint256 version, bytes32 ruleName);


    function initialize() external initializer {
        __Ownable_init();
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function setRuleContract(bytes32 _ruleGroupName, uint256 _version, address _ruleContract) external override onlyOwner {
        require(_version > 0, "Rule: version can't be zero");
        require(_ruleContract != address(0), "Rule: address can't be zero");
        GroupRule storage groupRule = groupRules[_ruleGroupName][_version];
        require(_ruleContract != groupRule.ruleContract, "Rule: contract already installed");

        groupRule.ruleContract = _ruleContract;
        emit SetRuleContract(_ruleGroupName, _version, _ruleContract);
    }

    function enableRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external override onlyOwner {
        require(_version > 0, "Rule: version can't be zero");
        GroupRule storage groupRule = groupRules[_ruleGroupName][_version];
        require(!groupRule.rules[_ruleName], "Rule: this rule already enabled");

        groupRule.rules[_ruleName] = true;
        emit EnableRule(_ruleGroupName, _version, _ruleName);
    }

    function disableRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external override onlyOwner {
        require(_version > 0, "Rule: version can't be zero");
        GroupRule storage groupRule = groupRules[_ruleGroupName][_version];
        require(groupRule.rules[_ruleName], "Rule: this rule already disabled");

        groupRule.rules[_ruleName] = false;
        emit DisableRule(_ruleGroupName, _version, _ruleName);
    }

    function isSupportedRule(
        bytes32 _ruleGroupName,
        uint256 _version,
        bytes32 _ruleName
    ) external view override returns (bool) {
        return groupRules[_ruleGroupName][_version].rules[_ruleName];
    }

    function getRuleContract(
        bytes32 _ruleGroupName,
        uint256 _version
    ) external view override returns (address)  {
        GroupRule storage groupRule = groupRules[_ruleGroupName][_version];
        return groupRule.ruleContract;
    }
}
