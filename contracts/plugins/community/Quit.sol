// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";


contract Quit is Context {

    uint256 private constant PLUGIN_VERSION = 1;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Quit: caller is not the executor");
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
    ) external onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (address _communityId) = abi.decode(data,(address));
        require(
            IAccount(registry.account()).removeCommunityUser(
                _executedId,
                PluginsList.COMMUNITY_QUIT,
                _version,
                _communityId,
                _sender
            ),
            "Quit: wrong create community"
        );

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Quit: wrong _version");
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_QUIT, _version),"Quit: plugin is not trusted");
        require(_sender != address(0) , "Quit: _sender is zero");
    }
}
