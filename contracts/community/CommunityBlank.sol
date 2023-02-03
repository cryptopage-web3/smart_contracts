// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../plugins/PluginsList.sol";
import "../registry/interfaces/IRegistry.sol";
import "../rules/interfaces/IRule.sol";
import "./interfaces/ICommunityBlank.sol";

/// @title Contract of Page.Community.CommunityBlank
/// @author Crypto.Page Team
/// @notice
/// @dev
contract CommunityBlank is
    Initializable,
    Ownable,
    ICommunityBlank
{

    string public name;
    address public creator;
    uint256 public creatingTime;
    uint256 public authorGasCompensationPercent;
    uint256 public ownerGasCompensationPercent;

    IRegistry registry;

    uint256 public constant INITIAL_PLUGINS_VERSION = 1;
    uint256 public constant ALL_PERCENT = 10000;

    // pluginName -> version -> linked
    mapping(bytes32 => mapping(uint256 => bool)) private linkedPlugins;
    // ruleGroupName -> version -> ruleName -> linked
    mapping(bytes32 => mapping(uint256 => mapping(bytes32 => bool))) private linkedRules;

    event LinkPlugin(address origin, address sender, bytes32 pluginName, uint256 version);
    event LinkPluginBatch(address origin, address sender, bytes32[] pluginNames, uint256[] versions);
    event UnLinkPlugin(address origin, address sender, bytes32 pluginName, uint256 version);
    event UnLinkPluginBatch(address origin, address sender, bytes32[] pluginNames, uint256[] versions);

    event LinkRule(address origin, address sender, bytes32 ruleGroupName, uint256 version, bytes32 ruleName);
    event UnLinkRule(address origin, address sender, bytes32 ruleGroupName, uint256 version, bytes32 ruleName);

    event ClaimERC20Token(address origin, address sender, address token, address receiver, uint256 amount);
    event SetGasCompensationPercent(address origin, address sender, uint256 authorPercent, uint256 ownerPercent);

    function initialize(
        string memory _name,
        address _registry,
        address _creator,
        bool _isInitial
    ) external initializer {
        _transferOwnership(_creator);
        name = _name;
        registry = IRegistry(_registry);
        creator = _creator;
        if (_isInitial) {
            setInitialPlugins();
        }
        creatingTime = block.timestamp;
    }

    function linkPlugin(bytes32 _pluginName, uint256 _version) external override onlyOwner {
        require(registry.isEnablePlugin(_pluginName, _version), "Community: wrong plugin");
        linkedPlugins[_pluginName][_version] = true;
        emit LinkPlugin(tx.origin, _msgSender(), _pluginName, _version);
    }

    function linkPluginBatch(bytes32[] calldata _pluginNames, uint256[] calldata _versions) external override onlyOwner {
        setStatusBatch(_pluginNames, _versions, true);
        emit LinkPluginBatch(tx.origin, _msgSender(), _pluginNames, _versions);
    }

    function unLinkPlugin(bytes32 _pluginName, uint256 _version) external override onlyOwner {
        linkedPlugins[_pluginName][_version] = false;
        emit UnLinkPlugin(tx.origin, _msgSender(), _pluginName, _version);
    }

    function unLinkPluginBatch(bytes32[] calldata _pluginNames, uint256[] calldata _versions) external override onlyOwner {
        setStatusBatch(_pluginNames, _versions, false);
        emit UnLinkPluginBatch(tx.origin, _msgSender(), _pluginNames, _versions);
    }

    function isLinkedPlugin(bytes32 _pluginName, uint256 _version) external view override returns (bool) {
        return linkedPlugins[_pluginName][_version];
    }

    function claimERC20Token(IERC20 _token, address _receiver, uint256 _amount) external override onlyOwner {
        require(_token.transfer(_receiver, _amount), "Community: token transfer error");
        emit ClaimERC20Token(tx.origin, _msgSender(), address(_token), _receiver, _amount);
    }

    function linkRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external override onlyOwner {
        require(
            IRule(registry.rule()).isSupportedRule(_ruleGroupName, _version, _ruleName),
                "Community: wrong rule"
        );
        linkedRules[_ruleGroupName][_version][_ruleName] = true;
        emit LinkRule(tx.origin, _msgSender(), _ruleGroupName, _version, _ruleName);
    }

    function unLinkRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external override onlyOwner {
        linkedRules[_ruleGroupName][_version][_ruleName] = false;
        emit UnLinkRule(tx.origin, _msgSender(), _ruleGroupName, _version, _ruleName);
    }

    function isLinkedRule(bytes32 _ruleGroupName, uint256 _version, bytes32 _ruleName) external view override returns (bool) {
        return linkedRules[_ruleGroupName][_version][_ruleName];
    }

    function setGasCompensationPercent(uint256 _authorPercent) external override onlyOwner {
        require(_authorPercent <= ALL_PERCENT, "Community: wrong percent");
        authorGasCompensationPercent = _authorPercent;
        ownerGasCompensationPercent = ALL_PERCENT - _authorPercent;
        emit SetGasCompensationPercent(tx.origin, _msgSender(), authorGasCompensationPercent, ownerGasCompensationPercent);
    }

    function setInitialPlugins() private {
        linkedPlugins[PluginsList.COMMUNITY_JOIN][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_QUIT][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_INFO][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_READ_POST][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_WRITE_POST][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_READ_COMMENT][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_WRITE_COMMENT][INITIAL_PLUGINS_VERSION] = true;
    }

    function setStatusBatch(bytes32[] calldata _pluginNames, uint256[] calldata _versions, bool _status) private {
        uint256 len = _pluginNames.length;
        require(len == _versions.length, "Community: wrong arrays length");
        for(uint256 i = 0; i < len; i++ ) {
            require(registry.isEnablePlugin(_pluginNames[i], _versions[i]), "Community: wrong plugin");
            linkedPlugins[_pluginNames[i]][_versions[i]] = _status;
        }
    }
}
