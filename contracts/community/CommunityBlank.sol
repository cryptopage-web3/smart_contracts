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

    IRegistry registry;

    uint256 public constant INITIAL_PLUGINS_VERSION = 1;

    // pluginName -> version -> linked
    mapping(bytes32 => mapping(uint256 => bool)) private linkedPlugins;
    // ruleGroupName -> version -> ruleName -> linked
    mapping(bytes32 => mapping(uint256 => mapping(bytes32 => bool))) private linkedRules;

    event LinkPlugin(address origin, address sender, bytes32 pluginName, uint256 version);
    event UnLinkPlugin(address origin, address sender, bytes32 pluginName, uint256 version);

    event LinkRule(address origin, address sender, bytes32 ruleGroupName, uint256 version, bytes32 ruleName);
    event UnLinkRule(address origin, address sender, bytes32 ruleGroupName, uint256 version, bytes32 ruleName);

    event ClaimERC20Token(address origin, address sender, address token, address receiver, uint256 amount);

    function initialize(
        string memory _name,
        address _registry,
        address _creator,
        bool _isInitial
    ) external initializer {
        _transferOwnership(creator);
        name = _name;
        registry = IRegistry(_registry);
        creator = _creator;
        if (_isInitial) {
            setInitialPlugins();
        }
    }

    function linkPlugin(bytes32 _pluginName, uint256 _version) external override onlyOwner {
        require(registry.isEnablePlugin(_pluginName, _version), "Community: wrong plugin");
        linkedPlugins[_pluginName][_version] = true;
        emit LinkPlugin(tx.origin, _msgSender(), _pluginName, _version);
    }

    function unLinkPlugin(bytes32 _pluginName, uint256 _version) external override onlyOwner {
        linkedPlugins[_pluginName][_version] = false;
        emit UnLinkPlugin(tx.origin, _msgSender(), _pluginName, _version);
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
            IRule(registry.rule()).isActiveRule(_ruleGroupName, _version, _ruleName),
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

    function setInitialPlugins() private {
        linkedPlugins[PluginsList.COMMUNITY_JOIN][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_QUIT][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_READ_POST][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_WRITE_POST][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_READ_COMMENT][INITIAL_PLUGINS_VERSION] = true;
        linkedPlugins[PluginsList.COMMUNITY_WRITE_COMMENT][INITIAL_PLUGINS_VERSION] = true;
    }
}
