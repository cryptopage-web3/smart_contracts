// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IReadPlugin.sol";


contract Info is Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_INFO;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        address _communityId
    ) external view returns(DataTypes.CommunityInfo memory outData) {
        checkPlugin(_communityId);

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

    function checkPlugin(address _communityId) private view {
        (bool enable, address pluginContract) = registry.getPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(enable, "Info: wrong enable plugin");
        require(pluginContract != address(0), "Info: wrong plugin contract");

        bool isLinked = ICommunityBlank(_communityId).isLinkedPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(isLinked, "Info: plugin is not linked for the community");
    }
}
