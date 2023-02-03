// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/IPostData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IModerationRules.sol";


contract Burn is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_BURN_COMMENT;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Write: caller is not the executor");
        _;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (uint256 _postId, ) =
        abi.decode(_data,(uint256, uint256));
        address _communityId = IPostData(registry.postData()).getCommunityId(_postId);

        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.MODERATION_RULES,
            PLUGIN_VERSION
        );
        require(
            IModerationRules(groupRules).validate(_communityId, _sender, _postId),
            "Burn: wrong validate"
        );

        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _sender;
        vars.data = _data;

        require(ICommentData(registry.commentData()).burnComment(vars),
            "Burn: wrong burning"
        );

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
