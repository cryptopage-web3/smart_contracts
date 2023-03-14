// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";
import "../BasePlugin.sol";


contract Info is BasePlugin {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_INFO;
        registry = IRegistry(_registry);
    }

    function read(
        address _communityId
    ) external view returns(DataTypes.CommunityInfo memory outData) {
        require(_communityId != address(0), "Info: wrong community");
        checkPlugin(PLUGIN_VERSION, _communityId);

        outData.creator = ICommunityBlank(_communityId).creator();
        outData.owner = Ownable(_communityId).owner();
        outData.name = ICommunityBlank(_communityId).name();
        outData.creatingTime = ICommunityBlank(_communityId).creatingTime();
        outData.postIds = ICommunityData(registry.communityData()).getPostIds(_communityId);

        (
            address[] memory normalUsers,
            address[] memory bannedUsers,
            address[] memory moderators
        ) = IAccount(registry.account()).getCommunityUsers(_communityId);
        outData.normalUsers = normalUsers;
        outData.bannedUsers = bannedUsers;
        outData.moderators = moderators;
    }
}
