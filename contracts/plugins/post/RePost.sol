// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../libraries/DataTypes.sol";
import "../BasePluginWithRules.sol";


contract RePost is IExecutePlugin, BasePluginWithRules{

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_REPOST;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        uint256 beforeGas = gasleft();

        DataTypes.GeneralVars memory postVars;
        postVars.executedId = _executedId;
        postVars.pluginName = PLUGIN_NAME;
        postVars.version = PLUGIN_VERSION;
        postVars.user = _sender;

        DataTypes.MinSimpleVars memory gasVars;
        gasVars.pluginName = PLUGIN_NAME;
        gasVars.version = PLUGIN_VERSION;

        (address _userCommunityId , uint256 _postId) = abi.decode(_data,(address, uint256));

        require(_userCommunityId != address(0), "RePost: wrong community");
        checkPlugin(_version, _userCommunityId);

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(_postId);
        DataTypes.PostInfo memory outData = IPostData(registry.postData()).readPost(vars);

        postVars.data = abi.encode(
            _userCommunityId, outData.repostFromCommunity, _sender, outData.ipfsHash, outData.encodingType, outData.tags, outData.isEncrypted, true
        );

        require(IAccount(registry.account()).isCommunityUser(_userCommunityId, _sender), "RePost: wrong _sender");

        checkRuleWithPostId(RulesList.POST_TRANSFERRING_RULES, _userCommunityId, _sender, _postId);
        checkBaseRule(RulesList.USER_VERIFICATION_RULES, _userCommunityId, _sender);
        checkBaseRule(RulesList.POST_PLACING_RULES, _userCommunityId, _sender);

        uint256 newPostId = IPostData(registry.postData()).writePost(postVars);
        require(newPostId > 0, "RePost: wrong create post");

        bytes memory newData = abi.encode(_userCommunityId, newPostId);
        postVars.data = newData;

        require(IAccount(registry.account()).addCreatedPostIdForUser(postVars),
            "RePost: wrong added postId for user"
        );

        require(ICommunityData(registry.communityData()).addCreatedPostIdForCommunity(postVars),
            "RePost: wrong added postId for community"
        );

        uint256 gasConsumption = beforeGas - gasleft();
        bytes memory gasData = abi.encode(newPostId, gasConsumption);
        gasVars.data = gasData;
        require(
            IPostData(registry.postData()).setGasConsumption(gasVars),
            "RePost: wrong set gasConsumption"
        );

        return true;
    }
}
