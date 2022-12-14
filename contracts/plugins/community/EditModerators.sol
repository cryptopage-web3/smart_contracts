// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../../rules/community/interfaces/ICommunityEditModeratorsRules.sol";
import "../interfaces/IExecutePlugin.sol";
import "../PluginsList.sol";


contract EditModerators is IExecutePlugin, Context {

    uint256 private constant PLUGIN_VERSION = 1;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "EditModerators: caller is not the executor");
        _;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata data
    ) external override onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (address _communityId, address _user, bool _isAdding) = abi.decode(data,(address, address, bool));
        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.COMMUNITY_EDIT_MODERATOR_RULES,
            PLUGIN_VERSION
        );
        require(
            ICommunityEditModeratorsRules(groupRules).validate(_communityId, _sender),
            "EditModerators: wrong validate"
        );
        if (_isAdding) {
            require(
                IAccount(registry.account()).addModerator(
                    _executedId,
                    PluginsList.COMMUNITY_JOIN,
                    _version,
                    _communityId,
                    _user
                ),
                "EditModerators: wrong add moderator"
            );
        } else {
            require(
                IAccount(registry.account()).removeModerator(
                    _executedId,
                    PluginsList.COMMUNITY_JOIN,
                    _version,
                    _communityId,
                    _user
                ),
                "EditModerators: wrong remove moderator"
            );
        }

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "EditModerators: wrong _version");
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_JOIN, _version),"EditModerators: plugin is not trusted");
        require(_sender != address(0) , "EditModerators: _sender is zero");
    }
}
