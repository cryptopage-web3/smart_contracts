// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";
import "../../libraries/UserLib.sol";
import "../BasePlugin.sol";


contract InfoAllCommunities is BasePlugin {

    using UserLib for IRegistry;

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.USER_INFO_ALL_COMMUNITIES;
        registry = IRegistry(_registry);
    }

    function read(
        address _user
    ) external view returns(DataTypes.UserRateCount memory) {
        checkPlugin(PLUGIN_VERSION, address(0));

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
}
