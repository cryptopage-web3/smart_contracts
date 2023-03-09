// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../../registry/interfaces/IRegistry.sol";
import "../../PluginsList.sol";
import "../../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../../libraries/MakeTokenId.sol";


contract BalanceOf is Context {
    using MakeTokenId for address;

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.SOULBOUND_BALANCE_OF;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        address _user,
        address _communityId,
        uint256 _rateId
    ) external view returns(uint256) {
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"BalanceOf: plugin is not trusted");
        uint256 tokenId = _communityId.getSoulBoundTokenId(_rateId);

        return ISoulBound(registry.soulBound()).balanceOf(_user, tokenId);
    }
}
