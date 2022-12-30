// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../bank/interfaces/IBank.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IGasCompensationRules.sol";


contract GasCompensation is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_COMMENT_GAS_COMPENSATION;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "GasCompensation: caller is not the executor");
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
        (uint256 postId, uint256[] memory commentIds) = abi.decode(_data,(uint256,uint256[]));

        for (uint256 i = 0; i < commentIds.length; i++) {
            uint256 commentId = commentIds[i];
            address communityId = IPostData(registry.postData()).getCommunityId(postId);
            (uint256 price, address creator) = ICommentData(registry.commentData()).setGasCompensation(
                _executedId,
                PLUGIN_NAME,
                PLUGIN_VERSION,
                postId,
                commentId
            );
            address user = checkRule(RulesList.GAS_COMPENSATION_RULES, communityId, creator);
            if(user != address(0)) {
                require(
                    IBank(registry.bank()).gasCompensation(
                        _executedId,
                        PLUGIN_NAME,
                        PLUGIN_VERSION,
                        user,
                        price
                    ),
                    "GasCompensation: wrong bank"
                );
            }
        }

        return true;
    }

    function checkRule(bytes32 _groupRulesName, address _communityId, address _sender) private view returns(address) {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        return IGasCompensationRules(rulesContract).validate(_communityId, _sender);
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "GasCompensation: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"GasCompensation: plugin is not trusted");
        require(_sender != address(0) , "GasCompensation: _sender is zero");
    }
}
