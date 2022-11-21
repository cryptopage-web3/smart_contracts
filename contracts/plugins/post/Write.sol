// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../plugins/interfaces/IAdrAdr.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";


contract Write {

    address public community;
    IRegistry public registry;

    string private constant pluginVersion = "1";

}
