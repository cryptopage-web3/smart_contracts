// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/community/RulesList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../PluginsList.sol";
import "../BasePluginWithRules.sol";


contract EditModerators is IExecutePlugin, BasePluginWithRules {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_EDIT_MODERATORS;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        (address _communityId, address _user, bool _isAdding) = abi.decode(_data,(address, address, bool));

        require(_communityId != address(0), "EditModerators: wrong community");
        checkPlugin(_version, _communityId);

        checkBaseRule(RulesList.COMMUNITY_EDIT_MODERATOR_RULES, _communityId, _sender);

        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _user;
        vars.data = _data;

        if (_isAdding) {
            require(
                IAccount(registry.account()).addModerator(vars),
                "EditModerators: wrong add moderator"
            );
        } else {
            require(
                IAccount(registry.account()).removeModerator(vars),
                "EditModerators: wrong remove moderator"
            );
        }

        return true;
    }
}
