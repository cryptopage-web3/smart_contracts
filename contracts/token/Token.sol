// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/IToken.sol";
import "../registry/interfaces/IRegistry.sol";

/// @title Contract of Page.Token
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Token is
    ERC20Upgradeable,
    AccessControlUpgradeable,
    IToken
{
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");

    address public registry;

    function initialize(address _registry) external initializer {
        __ERC20_init("Page.Token", "PAGE");
        require(_registry != address(0), "Token: address cannot be zero");

        registry = _registry;
        IRegistry reg = IRegistry(registry);
        address treasury = reg.treasury();
        _mint(treasury, 5e7);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function mint(address to, uint256 amount) public override onlyRole(MINT_ROLE) {
        require(to != address(0), "Token: address cannot be zero");
        _mint(to, amount);
    }

    function burn(address to, uint256 amount) public override onlyRole(BURN_ROLE) {
        require(to != address(0), "Token: address cannot be zero");
        _burn(to, amount);
    }
}
