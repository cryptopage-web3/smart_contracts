// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IReadPlugin.sol";
import "../../rules/community/interfaces/IPostCommentingRules.sol";


contract Read is IReadPlugin, Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_READ_COMMENT;

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

        (uint256 _postId, uint256 _commentId) =
        abi.decode(_inData,(uint256, uint256));

        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.POST_COMMENTING_RULES,
            PLUGIN_VERSION
        );

        address _communityId = IPostData(registry.postData()).getCommunityId(_postId);
        require(
            IPostCommentingRules(groupRules).validate(_communityId, _sender),
            "Write: wrong validate"
        );

        return ICommentData(registry.commentData()).readComment(
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _postId,
            _commentId
        );
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
