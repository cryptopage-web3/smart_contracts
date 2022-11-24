// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IRule {

    function version() external pure returns (string memory);

    function setRuleContract(bytes32 _ruleGroupName, uint256 _version, address _ruleContract) external;

    function enableRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external;

    function disableRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external;

    function isSupportedRule(
        bytes32 _ruleGroupName,
        uint256 _version,
        bytes32 _ruleName
    ) external view returns (bool);

    function getRuleContract(
        bytes32 _ruleGroupName,
        uint256 _version
    ) external view returns (address);

}
