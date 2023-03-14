// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../bank/interfaces/IBank.sol";
import "../BasePlugin.sol";


contract Withdraw is IExecutePlugin, BasePlugin {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.BANK_WITHDRAW;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        checkPlugin(PLUGIN_VERSION, address(0));

        (uint256 _amount) = abi.decode(_data,(uint256));

        return IBank(registry.bank()).withdraw(
            _executedId,
            PluginsList.BANK_WITHDRAW,
            _version,
            _sender,
            _amount
        );
    }
}
