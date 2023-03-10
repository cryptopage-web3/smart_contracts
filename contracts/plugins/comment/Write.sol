// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IBaseRules.sol";
import "../../rules/community/interfaces/IBaseRulesWithPostId.sol";
import "../../libraries/DataTypes.sol";
import "../BasePlugin.sol";


contract Write is IExecutePlugin, BasePlugin {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_WRITE_COMMENT;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        uint256 beforeGas = gasleft();
        require(_version == PLUGIN_VERSION, "Write: wrong version");

        (address _communityId , uint256 _postId, , , , , ) =
        abi.decode(_data,(address, uint256, address, string, bool, bool, bool));

        checkPlugin(_communityId);
        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        checkBaseRule(RulesList.USER_VERIFICATION_RULES, _communityId, _sender);
        checkRuleWithPostId(RulesList.POST_COMMENTING_RULES, _communityId, _sender, _postId);

        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _sender;
        vars.data = _data;

        DataTypes.MinSimpleVars memory gasVars;
        gasVars.pluginName = PLUGIN_NAME;
        gasVars.version = PLUGIN_VERSION;

        uint256 commentId = ICommentData(registry.commentData()).writeComment(vars);
        require(commentId > 0, "Write: wrong create comment");

        require(IPostData(registry.postData()).updatePostWhenNewComment(vars),
            "Write: wrong added commentId for user"
        );

        vars.data = abi.encode(_communityId, _postId, commentId);
        require(IAccount(registry.account()).addCreatedCommentIdForUser(vars),
            "Write: wrong added commentId for user"
        );

        uint256 gasPrice = beforeGas - gasleft();
        gasVars.data = abi.encode(_postId, commentId, gasPrice);
        require(
            ICommentData(registry.commentData()).setGasConsumption(gasVars),
            "Write: wrong set price"
        );

        return true;
    }

    function checkBaseRule(bytes32 _groupRulesName, address _communityId, address _sender) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRules(rulesContract).validate(_communityId, _sender),
            "RePost: wrong base rules validate"
        );
    }

    function checkRuleWithPostId(bytes32 _groupRulesName, address _communityId, address _sender, uint256 _postId) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRulesWithPostId(rulesContract).validate(_communityId, _sender, _postId),
            "RePost: wrong rules with postId validate"
        );
    }
}
