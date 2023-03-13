// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../../rules/community/interfaces/IPostCommentingRules.sol";
import "../../libraries/DataTypes.sol";
import "../BasePlugin.sol";


contract Read is BasePlugin {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_READ_COMMENT;
        registry = IRegistry(_registry);
    }

    function read(
        uint256 _postId,
        uint256 _commentId
    ) external view returns(DataTypes.CommentInfo memory outData) {
        address sender = _msgSender();
        address communityId = IPostData(registry.postData()).getCommunityId(_postId);

        checkPlugin(PLUGIN_VERSION, communityId);
        checkRule(RulesList.POST_COMMENTING_RULES, communityId, sender, _postId);

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(_postId, _commentId);

        outData = ICommentData(registry.commentData()).readComment(vars);
        outData.communityId = communityId;
    }

    function checkRule(bytes32 _groupRulesName, address _communityId, address _sender, uint256 _postId) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IPostCommentingRules(rulesContract).validate(_communityId, _sender, _postId),
            "Write: wrong rules validate"
        );
    }
}
