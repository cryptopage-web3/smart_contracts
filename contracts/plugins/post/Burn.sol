// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../libraries/DataTypes.sol";
import "../BasePluginWithRules.sol";


contract Burn is IExecutePlugin, BasePluginWithRules {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_BURN_POST;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        (uint256 _postId) = abi.decode(_data,(uint256));
        address _communityId = IPostData(registry.postData()).getCommunityId(_postId);

        require(_communityId != address(0), "Burn: wrong community");
        checkPlugin(_version, _communityId);

        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        checkRuleWithPostId(RulesList.MODERATION_RULES, _communityId, _sender, _postId);

        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _sender;
        vars.data = _data;

        require(IPostData(registry.postData()).burnPost(vars),
            "Burn: wrong burning"
        );

        return true;
    }
}
