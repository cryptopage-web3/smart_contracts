// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../interfaces/IExecutePlugin.sol";
import "../PluginsList.sol";
import "../BasePluginWithRules.sol";


contract Quit is IExecutePlugin, BasePluginWithRules {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_QUIT;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        (address _communityId) = abi.decode(_data,(address));

        require(_communityId != address(0), "Quit: wrong community");
        checkPlugin(_version, _communityId);

        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _sender;
        vars.data = _data;

        require(
            IAccount(registry.account()).removeCommunityUser(vars),
            "Quit: wrong create community"
        );

        return true;
    }
}
