// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../../bank/interfaces/IBank.sol";
import "../BasePlugin.sol";


contract BalanceOf is BasePlugin {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.BANK_BALANCE_OF;
        registry = IRegistry(_registry);
    }

    function read(
        address _sender
    ) external view returns(uint256) {
        checkPlugin(PLUGIN_VERSION, address(0));

        return IBank(registry.bank()).balanceOf(
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _sender
        );
    }
}
