// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IRule {

    function version() external pure returns (string memory);

    function setRuleContract(bytes32 ruleGroupName, address ruleContract) external;

    function setCommunityRule(bytes32 ruleGroupName, bytes32 ruleName, bool enable) external;

    function addCommunityToRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external;

    function removeRuleFromCommunity(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external;

    function isSupportedRule(bytes32 ruleGroupName, bytes32 ruleName, address communityID) external view returns (bool);

}
