// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../registry/interfaces/IRegistry.sol";
import "../../account/interfaces/IAccount.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../tokens/soulbound/interfaces/ISoulBound.sol";
import "../../libraries/DataTypes.sol";
import "../../libraries/MakeId.sol";


contract SoulBoundGenerator is IExecutePlugin, Context{

    using MakeId for address;

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.SOULBOUND_GENERATE;

    IRegistry public registry;
    ISoulBound public soulBound;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "SoulBoundGenerator: caller is not the executor");
        _;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
        soulBound = ISoulBound(registry.soulBound());
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (address _user, address _communityId) =
        abi.decode(_data,(address,address));

        DataTypes.UserRateCount memory rate = IAccount(registry.account()).getUserRate(_user, _communityId);

        makeMint(_user, _communityId, rate.postCount, uint256(DataTypes.UserRatesType.FOR_POST));
        makeMint(_user, _communityId, rate.commentCount, uint256(DataTypes.UserRatesType.FOR_COMMENT));
        makeMint(_user, _communityId, rate.upCount, uint256(DataTypes.UserRatesType.FOR_UP));
        makeMint(_user, _communityId, rate.downCount, uint256(DataTypes.UserRatesType.FOR_DOWN));

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "SoulBoundGenerator: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Deposit: plugin is not trusted");
        require(_sender != address(0) , "SoulBoundGenerator: _sender is zero");
    }

    function makeMint(address _user, address _communityId, uint256 _rateAmount, uint256 _rateId) private {
        uint256 tokenId = _communityId.getSoulBoundTokenId(_rateId);
        uint256 existTokensCount = soulBound.balanceOf(_user, tokenId);
        uint256 diff = _rateAmount - existTokensCount;
        if (diff > 0) {
            DataTypes.SoulBoundMintBurn memory vars;
            vars.user = _user;
            vars.pluginName = PLUGIN_NAME;
            vars.version = PLUGIN_VERSION;
            vars.id = tokenId;
            vars.amount = diff;
            soulBound.mint(vars);
        }
    }
}
