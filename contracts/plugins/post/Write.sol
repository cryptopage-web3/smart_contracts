// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../../rules/community/interfaces/ICommunityJoiningRules.sol";
import "../PluginsList.sol";


contract Write is Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_WRITE_POST;

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
    ) external onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (address _communityId , , , , ) =
        abi.decode(_data,(address, address, string, uint256, string[]));
        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        uint256 postId = IPostData(registry.postData()).writePost(
            _executedId,
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _sender,
            _data
        );
        require(postId > 0, "Write: wrong create post");

        require(IAccount(registry.account()).addCreatedPostIdForUser(
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _communityId,
                _sender,
                postId
            ),
            "Write: wrong added post id for user"
        );

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
