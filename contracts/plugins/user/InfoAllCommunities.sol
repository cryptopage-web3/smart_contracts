// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";
import "./libraries/UserLib.sol";


contract InfoAllCommunities is Context {

    using UserLib for IRegistry;

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.USER_INFO_ALL_COMMUNITIES;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        address _user
    ) external view returns(DataTypes.UserRateCount memory) {
        checkData(_user);

        address[] memory communities = IAccount(registry.account()).getCommunitiesByUser(_user);

        DataTypes.UserRateCount memory counts;

        for(uint256 i=0; i < communities.length; i++) {
            address communityId = communities[i];
            DataTypes.UserRateCount memory communityCounts = registry.getUserRate(_user, communityId);
            counts.postCount += communityCounts.postCount;
            counts.commentCount += communityCounts.commentCount;
            counts.upCount += communityCounts.upCount;
            counts.downCount += communityCounts.downCount;
        }

        return counts;
    }

    function checkData(address _user) private view {
        (bool enable, address pluginContract) = registry.getPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(pluginContract == address(this), "InfoAllCommunities: wrong contract");
        require(enable,"InfoAllCommunities: plugin is not active");
        require(_user != address(0) , "InfoAllCommunities: _user is zero");
    }
}
