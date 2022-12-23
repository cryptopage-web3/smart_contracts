// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

interface IToken is IERC20Upgradeable {
    function version() external pure returns (string memory);

//    function mint(address to, uint256 amount) external;
//
//    function burn(address to, uint256 amount) external;
}
