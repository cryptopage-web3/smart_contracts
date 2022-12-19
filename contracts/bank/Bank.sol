// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/IBank.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../tokens/token/interfaces/IToken.sol";

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
    IToken public token;

    mapping(address => uint256) private balances;

    event Deposit(bytes32 executedId, address indexed user, uint256 amount);
    event Withdraw(bytes32 executedId, address indexed user, uint256 amount);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Bank: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "Bank: caller is not the plugin"
        );
        _;
    }

    function initialize(address _registry)
        external
        initializer
    {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        registry = IRegistry(_registry);
        token = IToken(registry.token());
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    receive() external payable {}

    function deposit(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        uint256 _amount
    ) external override onlyTrustedPlugin(PluginsList.BANK_DEPOSIT, _pluginName, _version) {
        require(_amount > 0, "PageBank: wrong amount");
        require(token.transferFrom(_sender, address(this), _amount), "PageBank: wrong transfer of tokens");
        balances[_sender] += _amount;
        emit Deposit(_executedId, _sender, _amount);
    }

    function withdraw(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        uint256 _amount
    ) external override onlyTrustedPlugin(PluginsList.BANK_WITHDRAW, _pluginName, _version) {
        balances[_sender] -= _amount;
        require(token.transfer(_sender,  _amount), "PageBank: wrong transfer of tokens");
        emit Withdraw(_executedId, _sender, _amount);
    }

    function balanceOf(
        bytes32 _pluginName,
        uint256 _version,
        address _user
    ) external view override onlyTrustedPlugin(PluginsList.BANK_BALANCE_OF, _pluginName, _version) returns (uint256) {
        return balances[_user];
    }
}
