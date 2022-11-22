// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/IRegistry.sol";


/// @title Contract of Page.Registry
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Registry is OwnableUpgradeable, IRegistry {

    address public bank;
    address public token;
    address public dao;
    address public treasury;
    address public executor;
    address public rule;
    address public communityData;
    address public account;

    bytes32 public constant EMPTY_NAME = bytes32(0);

    struct Plugin {
        bool enable;
        uint256 typeInterface;
        address pluginContract;
    }

    // pluginName -> version -> Plugin
    mapping(bytes32 => mapping(uint256 => Plugin)) private plugins;

    event SetPlugin(address sender, bytes32 pluginName, uint256 version, address pluginContract, uint256 typeInterface);
    event ChangePluginStatus(address sender, bytes32 pluginName, uint256 version, bool newStatus);

    event SetExecutor(address origin, address sender, address oldValue, address newValue);
    event SetCommunityData(address origin, address sender, address oldValue, address newValue);
    event SetAccount(address origin, address sender, address oldValue, address newValue);

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    ///constructor() initializer {}

    function initialize(
        address _bank,
        address _token,
        address _dao,
        address _treasury,
        address _rule
    ) external initializer {
        __Ownable_init();
        bank = _bank;
        token = _token;
        dao = _dao;
        treasury = _treasury;
        rule = _rule;
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function setPlugin(
        bytes32 _pluginName,
        uint256 _version,
        address _pluginContract,
        uint256 _typeInterface
    ) external override onlyOwner {

        require(_pluginName != EMPTY_NAME, "Registry: plugin name can't be empty");
        require(_version > 0, "Registry: the version must be greater than zero");
        require(_pluginContract != address(0), "Registry: address can't be zero");

        Plugin storage plugin = plugins[_pluginName][_version];
        require(_pluginContract != plugin.pluginContract, "Registry: contract already installed");
        plugin.enable = true;
        plugin.pluginContract = _pluginContract;
        plugin.typeInterface = _typeInterface;

        emit SetPlugin(_msgSender(), _pluginName, _version, _pluginContract, _typeInterface);
    }

    function setExecutor(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetExecutor(tx.origin, _msgSender(), executor, _contract);
        executor = _contract;
    }

    function setCommunityData(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetCommunityData(tx.origin, _msgSender(), communityData, _contract);
        communityData = _contract;
    }

    function setAccount(address _account) external override onlyOwner {
        require(_account != address(0), "Registry: address can't be zero");
        emit SetAccount(tx.origin, _msgSender(), account, _account);
        account = _account;
    }

    function changePluginStatus(
        bytes32 _pluginName,
        uint256 _version
    ) external override onlyOwner {
        Plugin storage plugin = plugins[_pluginName][_version];
        require(plugin.pluginContract != address(0), "Registry: contract already installed");
        plugin.enable = !plugin.enable;

        emit ChangePluginStatus(_msgSender(), _pluginName, _version, plugin.enable);
    }

    function getPlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view override returns (bool enable, uint256 typeInterface, address pluginContract)  {
        Plugin storage plugin = plugins[_pluginName][_version];
        enable = plugin.enable;
        typeInterface = plugin.typeInterface;
        pluginContract = plugin.pluginContract;
    }

    function getPluginContract(
        bytes32 _pluginName,
        uint256 _version
    ) external view override returns (address pluginContract)  {
        Plugin storage plugin = plugins[_pluginName][_version];
        return plugin.pluginContract;
    }

    function isEnablePlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view override returns (bool enable)  {
        Plugin storage plugin = plugins[_pluginName][_version];
        enable = plugin.enable;
    }
}
