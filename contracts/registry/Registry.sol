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
    address public oracle;
    address public uniV3Pool;
    address public token;
    address public dao;
    address public treasury;
    address public executor;
    address public rule;
    address public communityData;
    address public postData;
    address public commentData;
    address public account;
    address public badge;
    address public nft;

    bytes32 public constant EMPTY_NAME = bytes32(0);

    struct Plugin {
        bool enable;
        address pluginContract;
    }

    // pluginName -> version -> Plugin
    mapping(bytes32 => mapping(uint256 => Plugin)) private plugins;

    event SetPlugin(address sender, bytes32 pluginName, uint256 version, address pluginContract);
    event ChangePluginStatus(address sender, bytes32 pluginName, uint256 version, bool newStatus);

    event SetBank(address origin, address sender, address oldValue, address newValue);
    event SetOracle(address origin, address sender, address oldValue, address newValue);
    event SetUniV3Pool(address origin, address sender, address oldValue, address newValue);
    event SetExecutor(address origin, address sender, address oldValue, address newValue);
    event SetCommunityData(address origin, address sender, address oldValue, address newValue);
    event SetPostData(address origin, address sender, address oldValue, address newValue);
    event SetCommentData(address origin, address sender, address oldValue, address newValue);
    event SetAccount(address origin, address sender, address oldValue, address newValue);
    event SetBadge(address origin, address sender, address oldValue, address newValue);
    event SetRule(address origin, address sender, address oldValue, address newValue);
    event SetNFT(address origin, address sender, address oldValue, address newValue);

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    ///constructor() initializer {}

    function initialize(
        address _token,
        address _dao,
        address _treasury
    ) external initializer {
        __Ownable_init();
        token = _token;
        dao = _dao;
        treasury = _treasury;
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function setPlugin(
        bytes32 _pluginName,
        uint256 _version,
        address _pluginContract
    ) external override onlyOwner {

        require(_pluginName != EMPTY_NAME, "Registry: plugin name can't be empty");
        require(_version > 0, "Registry: the version must be greater than zero");
        require(_pluginContract != address(0), "Registry: address can't be zero");

        Plugin storage plugin = plugins[_pluginName][_version];
        require(_pluginContract != plugin.pluginContract, "Registry: contract already installed");
        plugin.enable = true;
        plugin.pluginContract = _pluginContract;

        emit SetPlugin(_msgSender(), _pluginName, _version, _pluginContract);
    }

    function setBank(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetBank(tx.origin, _msgSender(), bank, _contract);
        bank = _contract;
    }

    function setOracle(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetOracle(tx.origin, _msgSender(), oracle, _contract);
        oracle = _contract;
    }

    function setUniV3Pool(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetUniV3Pool(tx.origin, _msgSender(), uniV3Pool, _contract);
        uniV3Pool = _contract;
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

    function setPostData(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetPostData(tx.origin, _msgSender(), postData, _contract);
        postData = _contract;
    }

    function setCommentData(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetCommentData(tx.origin, _msgSender(), commentData, _contract);
        commentData = _contract;
    }

    function setAccount(address _account) external override onlyOwner {
        require(_account != address(0), "Registry: address can't be zero");
        emit SetAccount(tx.origin, _msgSender(), account, _account);
        account = _account;
    }

    function setBadge(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetBadge(tx.origin, _msgSender(), badge, _contract);
        badge = _contract;
    }

    function setRule(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetRule(tx.origin, _msgSender(), rule, _contract);
        rule = _contract;
    }

    function setNFT(address _contract) external override onlyOwner {
        require(_contract != address(0), "Registry: address can't be zero");
        emit SetNFT(tx.origin, _msgSender(), nft, _contract);
        nft = _contract;
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
    ) external view override returns (bool enable, address pluginContract)  {
        Plugin storage plugin = plugins[_pluginName][_version];
        enable = plugin.enable;
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
