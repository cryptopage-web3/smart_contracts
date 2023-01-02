// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


interface ICommunityBlank {

    function creator() external view returns (address);

    function name() external view returns (string memory);

    function creatingTime() external view returns (uint256);

    function authorGasCompensationPercent() external view returns (uint256);

    function ownerGasCompensationPercent() external view returns (uint256);

    function linkPlugin(bytes32 _pluginName, uint256 _version) external;

    function unLinkPlugin(bytes32 _pluginName, uint256 _version) external;

    function isLinkedPlugin(bytes32 _pluginName, uint256 _version) external view returns (bool);

    function linkRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external;

    function unLinkRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external;

    function isLinkedRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external view returns (bool);

    function claimERC20Token(IERC20 _token, address _receiver, uint256 _amount) external;

    function setGasCompensationPercent(uint256 _authorPercent) external;
}
