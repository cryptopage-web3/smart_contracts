// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IBank {
    function version() external pure returns (string memory);

    function deposit(uint amount) external;

    function withdraw(uint256 amount) external;

    function transfer(address to, uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external;

    function balanceOf(address user) external view returns (uint256);
}
