// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";
import "./libraries/UserLib.sol";


contract InfoByCommunity is Context {

    using UserLib for IRegistry;

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.USER_INFO_ONE_COMMUNITY;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        address _user,
        address _communityId
    ) external view returns(DataTypes.UserRateCount memory) {
        checkData(_user);
        return registry.getUserRate(_user, _communityId);
    }

    function checkData(address _user) private view {
        (bool enable, address pluginContract) = registry.getPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(pluginContract == address(this), "InfoByCommunity: wrong contract");
        require(enable,"InfoByCommunity: plugin is not active");
        require(_user != address(0) , "InfoByCommunity: _user is zero");
    }
}
