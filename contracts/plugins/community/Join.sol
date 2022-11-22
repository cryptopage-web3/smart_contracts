// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";


contract Join is Ownable {

    uint256 private constant PLUGIN_VERSION = 1;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Join: caller is not the executor");
        _;
    }

    constructor(address _registry, address _owner) {
        _transferOwnership(_owner);
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        uint256 _version,
        address _sender,
        bytes calldata data
    ) external onlyExecutor {
        checkData(_version, _sender);
        (address _communityId) = abi.decode(data,(address));
        require(
            IAccount(registry.account()).addCommunityUser(
                PluginsList.COMMUNITY_CREATE,
                _version,
                _communityId,
                _sender
            ),
            "Join: wrong create community"
        );
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Join: wrong _version");
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_JOIN, _version),"Create: plugin is not trusted");
        require(_sender != address(0) , "Join: _sender is not zero");
    }
}
