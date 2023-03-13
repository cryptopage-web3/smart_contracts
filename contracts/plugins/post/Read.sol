// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/nft/interfaces/INFT.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";
import "../BasePluginWithRules.sol";


contract Read is BasePluginWithRules {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_READ_POST;
        registry = IRegistry(_registry);
    }

    function read(
        uint256 _postId
    ) external view returns(DataTypes.PostInfo memory outData) {
        address sender = _msgSender();
        address communityId = IPostData(registry.postData()).getCommunityId(_postId);

        checkPlugin(PLUGIN_VERSION, communityId);
        checkRuleWithPostId(RulesList.POST_READING_RULES, communityId, sender, _postId);

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(_postId);

        outData = IPostData(registry.postData()).readPost(vars);
        outData.communityId = communityId;
        outData.currentOwner = INFT(registry.nft()).ownerOf(_postId);
        outData.commentCount = ICommentData(registry.commentData()).getCommentCount(_postId);
    }
}
