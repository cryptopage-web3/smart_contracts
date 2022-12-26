// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/IOracle.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../tokens/token/interfaces/IToken.sol";


contract Oracle is IOracle, ContextUpgradeable {

    IRegistry public registry;
    IToken public token;

    function initialize(address _registry) external initializer {
        registry = IRegistry(_registry);
        token = IToken(registry.token());
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

}
