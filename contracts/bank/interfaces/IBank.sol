// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IBank {

    function version() external pure returns (string memory);

    function deposit(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        uint256 _amount
    ) external returns(bool);

    function withdraw(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        uint256 _amount
    ) external returns(bool);

    function balanceOf(
        bytes32 _pluginName,
        uint256 _version,
        address user
    ) external view returns (uint256);
}
