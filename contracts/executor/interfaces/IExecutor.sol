// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IExecutor {

    function setValidator(address _validator) external;

    function run(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes calldata _data) external;

    function gasLessRun(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes calldata _data) external;

}
