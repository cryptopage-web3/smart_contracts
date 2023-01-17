// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IChangeVisibilityContentRules.sol";


contract ChangeVisibility is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_CHANGE_VISIBILITY_COMMENT;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "ChangeVisibility: caller is not the executor");
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
        abi.decode(_data,(uint256, bool));
        address _communityId = IPostData(registry.postData()).getCommunityId(_postId);

        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "ChangeVisibility: wrong _sender");

        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.CHANGE_VISIBILITY_CONTENT_RULES,
            PLUGIN_VERSION
        );
        require(
            IChangeVisibilityContentRules(groupRules).validate(_communityId, _sender),
            "ChangeVisibility: wrong validate"
        );

        DataTypes.SimpleVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = _data;

        require(ICommentData(registry.commentData()).setVisibility(vars),
            "ChangeVisibility: wrong set visibility"
        );

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "ChangeVisibility: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"ChangeVisibility: plugin is not trusted");
        require(_sender != address(0) , "ChangeVisibility: _sender is zero");
    }
}
