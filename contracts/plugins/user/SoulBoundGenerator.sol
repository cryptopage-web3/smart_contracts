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


contract SoulBoundGenerator is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.SOULBOUND_GENERATE;

    struct RedeemedCount {
        uint64[3] messageCount;
        uint64[3] postCount;
        uint64[2] upCount;
        uint64[2] downCount;
    }

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


        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "SoulBoundGenerator: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Deposit: plugin is not trusted");
        require(_sender != address(0) , "SoulBoundGenerator: _sender is zero");
    }

    function checkCommentsByIndex(
        uint256 tokenId,
        uint256 communityId,
        address user,
        uint256 realCommentsCount,
        uint256 index
    ) private {
        RedeemedCount storage redeemCounter = redeemedCounter[communityId][user];

        uint256 number = realCommentsCount / (10 * 10**index);
        uint64 mintNumber = uint64(number) - redeemCounter.messageCount[index];
        if (mintNumber > 0) {
            redeemCounter.messageCount[index] += mintNumber;
            userRateToken.mint(
                user, tokenId + uint256(UserRatesType.TEN_MESSAGE) + index, mintNumber, FOR_RATE_TOKEN_DATA
            );
        }
    }

}
