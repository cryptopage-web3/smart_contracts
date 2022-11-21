// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/IBank.sol";
import "../registry/interfaces/IRegistry.sol";
import "../token/interfaces/IToken.sol";

/// @title Contract of Page.Bank
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Bank is
    Initializable,
    AccessControlUpgradeable,
    IBank
{
    bytes32 public constant BALANCE_MANAGER_ROLE = keccak256("BALANCE_MANAGER_ROLE");

    IRegistry public registry;

    mapping(address => uint256) private balances;

    function initialize(address _registry)
        external
        initializer
    {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        registry = IRegistry(_registry);
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    receive() external payable {}

    function deposit(uint256 amount) external override {
        IToken token = IToken(registry.token());

        token.transferFrom(_msgSender(), address(this), amount);
        balances[_msgSender()] += amount;
    }

    function withdraw(uint256 amount) external override {
        IToken token = IToken(registry.token());

        balances[_msgSender()] -= amount;
        token.transferFrom(address(this), _msgSender(), amount);
    }

    function transfer(address to, uint256 amount) external override {
        balances[_msgSender()] -= amount;
        balances[to] += amount;
    }

    function transferFrom(address from, address to, uint256 amount) external override onlyRole(BALANCE_MANAGER_ROLE) {
        balances[from] -= amount;
        balances[to] += amount;
    }

    function balanceOf(address user) external view override returns (uint256) {
        return balances[user];
    }
}
