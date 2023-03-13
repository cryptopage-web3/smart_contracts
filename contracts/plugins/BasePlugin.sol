// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../registry/interfaces/IRegistry.sol";
import "../community/interfaces/ICommunityBlank.sol";


abstract contract BasePlugin is Context {

    uint256 internal PLUGIN_VERSION;
    bytes32 public PLUGIN_NAME;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "BasePlugin: caller is not the executor");
        _;
    }

    function version() external view returns (uint256) {
        return PLUGIN_VERSION;
    }

    function checkPlugin(uint256 _version, address _communityId) internal virtual view {
        require(_version == PLUGIN_VERSION, "BasePlugin: wrong version");
        (bool enable, address pluginContract) = registry.getPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(enable, "BasePlugin: wrong enable plugin");
        require(pluginContract != address(0), "BaseWritePlugin: wrong plugin contract");

        bool isLinked = ICommunityBlank(_communityId).isLinkedPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(isLinked, "BasePlugin: plugin is not linked for the community");
    }
}
