// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../../registry/interfaces/IRegistry.sol";
import "../../PluginsList.sol";
import "../../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../../libraries/MakeTokenId.sol";
import "../../BasePlugin.sol";


contract BalanceOf is BasePlugin {

    using MakeTokenId for address;

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.SOULBOUND_BALANCE_OF;
        registry = IRegistry(_registry);
    }

    function read(
        address _user,
        address _communityId,
        uint256 _rateId
    ) external view returns(uint256) {
        checkPlugin(PLUGIN_VERSION, address(0));
        uint256 tokenId = _communityId.getSoulBoundTokenId(_rateId);

        return ISoulBound(registry.soulBound()).balanceOf(_user, tokenId);
    }
}
