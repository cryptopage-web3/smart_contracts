// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../../bank/interfaces/IBank.sol";


contract BalanceOf is Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.BANK_BALANCE_OF;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        address _sender
    ) external view returns(uint256) {
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"BalanceOf: plugin is not trusted");
        require(_sender != address(0) , "BalanceOf: _sender is zero");

        return IBank(registry.bank()).balanceOf(
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _sender
        );
    }
}
