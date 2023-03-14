// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";
import "../../libraries/UserLib.sol";
import "../BasePlugin.sol";


contract InfoByCommunity is BasePlugin {

    using UserLib for IRegistry;

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.USER_INFO_ONE_COMMUNITY;
        registry = IRegistry(_registry);
    }

    function read(
        address _user,
        address _communityId
    ) external view returns(DataTypes.UserRateCount memory) {
        checkPlugin(PLUGIN_VERSION, address(0));
        return registry.getUserRate(_user, _communityId);
    }
}
