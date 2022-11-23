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
//        uint256 version;
        mapping(bytes32 => CommunityRuleSettings) rules;
    }

    struct CommunityRuleSettings {
        bool enable;
        EnumerableSetUpgradeable.AddressSet assignedCommunityIds;
    }

    mapping(bytes32 => GroupRule) public communityGroupRules;

    event SetRuleContract(bytes32 ruleGroupName, address ruleContract);
    event SetCommunityRule(bytes32 ruleGroupName, bytes32 ruleName, bool enable);
    event AddedCommunityToRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID);
    event RemovedCommunityFromRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID);

    function initialize() external initializer {
        __Ownable_init();
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function setRuleContract(bytes32 ruleGroupName, address ruleContract) external override onlyOwner {
        require(ruleContract != address(0), "Rule: address can't be zero");
        require(ruleContract != communityGroupRules[ruleGroupName].ruleContract, "Rule: contract already installed");

        communityGroupRules[ruleGroupName].ruleContract = ruleContract;
        emit SetRuleContract(ruleGroupName, ruleContract);
    }

    function setCommunityRule(bytes32 ruleGroupName, bytes32 ruleName, bool enable) external override onlyOwner {
        validateRuleNames(ruleGroupName, ruleName);
        require(enable != communityGroupRules[ruleGroupName].rules[ruleName].enable, "Rule: same condition");

        communityGroupRules[ruleGroupName].rules[ruleName].enable = enable;
        emit SetCommunityRule(ruleGroupName, ruleName, enable);
    }

    function addCommunityToRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external override onlyOwner {
        validateRule(ruleGroupName, ruleName, communityID);

        communityGroupRules[ruleGroupName].rules[ruleName].assignedCommunityIds.add(communityID);
        emit AddedCommunityToRule(ruleGroupName, ruleName, communityID);
    }

    function removeRuleFromCommunity(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external override onlyOwner {
        validateRule(ruleGroupName, ruleName, communityID);

        communityGroupRules[ruleGroupName].rules[ruleName].assignedCommunityIds.remove(communityID);
        emit RemovedCommunityFromRule(ruleGroupName, ruleName, communityID);
    }

    function isSupportedRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external view override returns (bool) {
        validateRuleNames(ruleGroupName, ruleName);
        return communityGroupRules[ruleGroupName].rules[ruleName].assignedCommunityIds.contains(communityID);
    }

    function validateRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID) private view {
        validateRuleNames(ruleGroupName, ruleName);
        require(communityID != address(0), "Rule: community ID can't be zero");
        require(communityGroupRules[ruleGroupName].rules[ruleName].enable, "Rule: rule must be enabled");
    }

    function validateRuleNames(bytes32 ruleGroupName, bytes32 ruleName) private pure {
        require(ruleGroupName != EMPTY_NAME, "Rule: rule group name can't be empty");
        require(ruleName != EMPTY_NAME, "Rule: rule name can't be empty");
    }
}
