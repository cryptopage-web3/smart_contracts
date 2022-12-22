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
import "../../rules/community/interfaces/IPostCommentingRules.sol";
import "../../rules/community/interfaces/IUserVerificationRules.sol";


contract Write is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_WRITE_COMMENT;

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
        uint256 beforeGas = gasleft();

        checkData(_version, _sender);
        (address _communityId , uint256 _postId, , , , , ) =
        abi.decode(_data,(address, uint256, address, string, bool, bool, bool));
        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.POST_COMMENTING_RULES,
            PLUGIN_VERSION
        );
        require(
            IPostCommentingRules(groupRules).validate(_communityId, _sender),
            "Write: wrong validate POST_COMMENTING_RULES"
        );

        groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.USER_VERIFICATION_RULES,
            PLUGIN_VERSION
        );
        require(
            IUserVerificationRules(groupRules).validate(_communityId, _sender),
            "Write: wrong validate USER_VERIFICATION_RULES"
        );

       uint256 commentId = ICommentData(registry.commentData()).writeComment(
            _executedId,
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _sender,
            _data
        );
        require(commentId > 0, "Write: wrong create comment");

        require(IPostData(registry.postData()).updatePostWhenNewComment(
                _executedId,
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _sender,
                _data
            ),
            "Write: wrong added commentId for user"
        );

        require(IAccount(registry.account()).addCreatedCommentIdForUser(
                _executedId,
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _communityId,
                _sender,
                _postId,
                commentId
            ),
            "Write: wrong added commentId for user"
        );

        uint256 gasPrice = beforeGas - gasleft();
        require(
            ICommentData(registry.commentData()).setPrice(
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _postId,
                commentId,
                gasPrice
            ),
            "Write: wrong set price"
        );

    return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
