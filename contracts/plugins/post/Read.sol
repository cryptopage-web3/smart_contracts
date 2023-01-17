// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IReadPlugin.sol";
import "../../rules/community/interfaces/IPostPlacingRules.sol";
import "../../libraries/DataTypes.sol";


contract Read is IReadPlugin, Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_READ_POST;

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

    function read(
        uint256 _version,
        address _sender,
        bytes calldata _inData
    ) external override onlyExecutor view returns(bytes memory) {
        checkData(_version, _sender);

        (uint256 postId) = abi.decode(_inData,(uint256));
        address communityId = IPostData(registry.postData()).getCommunityId(postId);
        uint256 commentCount = ICommentData(registry.commentData()).getCommentCount(postId);

        checkRule(RulesList.POST_READING_RULES, communityId, _sender);

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = _inData;

        bytes memory postData = IPostData(registry.postData()).readPost(vars);

        bytes memory outData = abi.encode(communityId, commentCount, postData);

        return outData;
    }

    function checkRule(bytes32 _groupRulesName, address _communityId, address _sender) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IPostPlacingRules(rulesContract).validate(_communityId, _sender),
            "Write: wrong rules validate"
        );
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
