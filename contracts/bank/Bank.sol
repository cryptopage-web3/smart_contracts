// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/IBank.sol";
import "./interfaces/IOracle.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../tokens/token/interfaces/IToken.sol";
import "../libraries/DataTypes.sol";

/// @title Contract of Page.Bank
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Bank is IBank, ContextUpgradeable {

    uint256 public constant ALL_PERCENT = 10000;
    uint256 public constant TREASURE_FEE = 1000;

    IRegistry public registry;
    IToken public token;

    mapping(address => uint256) private balances;

    event Deposit(bytes32 executedId, address indexed user, uint256 amount);
    event Withdraw(bytes32 executedId, address indexed user, uint256 amount);
    event GasCompensation(bytes32 executedId, address indexed user, uint256 amount);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Bank: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "Bank: caller is not the plugin"
        );
        _;
    }

    modifier onlyGasCompensationPlugins(bytes32 _checkedPluginName, uint256 _version) {
        require(PluginsList.COMMUNITY_POST_GAS_COMPENSATION == _checkedPluginName
        || PluginsList.COMMUNITY_COMMENT_GAS_COMPENSATION == _checkedPluginName,
            "Bank: wrong plugin name"
        );
        require(
            registry.getPluginContract(PluginsList.COMMUNITY_POST_GAS_COMPENSATION, _version) == _msgSender()
            || registry.getPluginContract(PluginsList.COMMUNITY_COMMENT_GAS_COMPENSATION, _version) == _msgSender(),
            "Bank: caller is not the plugin"
        );
        _;
    }

    function initialize(address _registry) external initializer {
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
    ) external override onlyTrustedPlugin(PluginsList.BANK_DEPOSIT, _pluginName, _version) returns(bool) {
        require(_amount > 0, "PageBank: wrong amount");
        require(token.transferFrom(_sender, address(this), _amount), "PageBank: wrong transfer of tokens");
        balances[_sender] += _amount;
        emit Deposit(_executedId, _sender, _amount);

        return true;
    }

    function withdraw(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        uint256 _amount
    ) external override onlyTrustedPlugin(PluginsList.BANK_WITHDRAW, _pluginName, _version) returns(bool) {
        balances[_sender] -= _amount;
        require(token.transfer(_sender,  _amount), "PageBank: wrong transfer of tokens");
        emit Withdraw(_executedId, _sender, _amount);

        return true;
    }

    function gasCompensation(
        DataTypes.GasCompensationBank calldata vars
    ) external override onlyGasCompensationPlugins(vars.pluginName, vars.version) returns(bool) {
        uint256 amount = convertGasToTokenAmount(vars.gas);
        require(amount > 0, "PageBank: wrong amount");
        require(token.mint(address(this), amount), "PageBank: wrong mint of tokens");
        uint256 treasureAmount = amount * TREASURE_FEE / ALL_PERCENT;
        balances[registry.treasury()] += treasureAmount;
        uint256 userAmount = amount - treasureAmount;
        balances[vars.user] += userAmount;
        emit GasCompensation(vars.executedId, vars.user, userAmount);

        return true;
    }

    function balanceOf(
        bytes32 _pluginName,
        uint256 _version,
        address _user
    ) external view override onlyTrustedPlugin(PluginsList.BANK_BALANCE_OF, _pluginName, _version) returns (uint256) {
        return balances[_user];
    }

    function convertGasToTokenAmount(uint256 _gas) private view returns (uint256) {
        return IOracle(registry.oracle()).getFromWethToPageAmount(_gas);
    }
}
