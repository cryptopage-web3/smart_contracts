// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../community/interfaces/IPostData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../../rules/community/interfaces/ICommunityJoiningRules.sol";
import "../PluginsList.sol";


contract Write is Context{

    uint256 private constant PLUGIN_VERSION = 1;

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
        uint256 postId = IPostData(registry.postData()).writePost(
            _executedId,
            PluginsList.COMMUNITY_WRITE_POST,
            _version,
            _sender,
            _data
        );
        require(postId > 0, "Write: wrong create post");

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Join: wrong _version");
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_WRITE_POST, _version),"Join: plugin is not trusted");
        require(_sender != address(0) , "Join: _sender is zero");
    }
}
