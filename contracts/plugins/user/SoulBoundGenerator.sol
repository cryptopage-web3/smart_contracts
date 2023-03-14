// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../registry/interfaces/IRegistry.sol";
import "../../account/interfaces/IAccount.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../libraries/DataTypes.sol";
import "../../libraries/MakeTokenId.sol";
import "../../libraries/UserLib.sol";
import "../BasePluginWithRules.sol";


contract SoulBoundGenerator is IExecutePlugin, BasePluginWithRules {

    using UserLib for IRegistry;
    using MakeTokenId for address;

    ISoulBound public soulBound;

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.SOULBOUND_GENERATE;
        registry = IRegistry(_registry);
        soulBound = ISoulBound(registry.soulBound());
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address ,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        (address _user, address _communityId) = abi.decode(_data,(address,address));

        require(_communityId != address(0), "SoulBoundGenerator: wrong community");
        checkPlugin(_version, _communityId);
        require(IAccount(registry.account()).isCommunityUser(_communityId, _user), "SoulBoundGenerator: wrong _user");
        checkBaseRule(RulesList.REPUTATION_MANAGEMENT_RULES, _communityId, _user);

        DataTypes.UserRateCount memory rate = registry.getUserRate(_user, _communityId);

        makeMint(_executedId, _user, _communityId, rate.postCount, uint256(DataTypes.UserRatesType.FOR_POST));
        makeMint(_executedId, _user, _communityId, rate.commentCount, uint256(DataTypes.UserRatesType.FOR_COMMENT));
        makeMint(_executedId, _user, _communityId, rate.upCount, uint256(DataTypes.UserRatesType.FOR_UP));
        makeMint(_executedId, _user, _communityId, rate.downCount, uint256(DataTypes.UserRatesType.FOR_DOWN));

        return true;
    }

    function makeMint(bytes32 _executedId, address _user, address _communityId, uint256 _rateAmount, uint256 _rateId) private {
        uint256 tokenId = _communityId.getSoulBoundTokenId(_rateId);
        uint256 existTokensCount = soulBound.balanceOf(_user, tokenId);
        uint256 diff = _rateAmount - existTokensCount;
        if (diff > 0) {
            DataTypes.SoulBoundMint memory vars;
            vars.executedId = _executedId;
            vars.user = _user;
            vars.pluginName = PLUGIN_NAME;
            vars.version = PLUGIN_VERSION;
            vars.id = tokenId;
            vars.amount = diff;
            soulBound.mint(vars);
        }
    }
}
