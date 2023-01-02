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
import "../../community/interfaces/ICommunityBlank.sol";
import "../../libraries/DataTypes.sol";


contract GasCompensation is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    uint256 public constant ALL_PERCENT = 10000;
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

        DataTypes.GasCompensationComment memory commentVars;
        commentVars.executedId = _executedId;
        commentVars.version = PLUGIN_VERSION;
        commentVars.pluginName = PLUGIN_NAME;
        commentVars.postId = postId;

        DataTypes.GasCompensationBank memory bankVars;
        bankVars.executedId = _executedId;
        bankVars.version = PLUGIN_VERSION;
        bankVars.pluginName = PLUGIN_NAME;

        for (uint256 i = 0; i < commentIds.length; i++) {
            address communityId = IPostData(registry.postData()).getCommunityId(postId);
            commentVars.commentId = commentIds[i];
            (uint256 gas, address creator, address owner) = ICommentData(registry.commentData()).setGasCompensation(
                commentVars
            );
            address[] memory users = checkRule(RulesList.GAS_COMPENSATION_RULES, communityId, creator, owner);
            uint256[] memory gasAmount = new uint256[](2);
            uint256 step = 1;
            if(users[1] != address(0)) {
                step = 2;
                gasAmount[0] = gas * ICommunityBlank(communityId).authorGasCompensationPercent() / ALL_PERCENT;
                gasAmount[1] = gas - gasAmount[0];
            } else {
                gasAmount[0] = gas;
            }
            for(uint256 j = 0; j < step; j++) {
                if(users[j] != address(0)) {
                    bankVars.user = users[j];
                    bankVars.gas = gasAmount[j];
                    require(
                        IBank(registry.bank()).gasCompensation(
                            bankVars
                        ),
                        "GasCompensation: wrong bank"
                    );
                }
            }
        }

        return true;
    }

    function checkRule(
        bytes32 _groupRulesName,
        address _communityId,
        address _author, address
        _owner
    ) private view returns(address[] memory) {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        return IGasCompensationRules(rulesContract).validate(_communityId, _author, _owner);
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "GasCompensation: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"GasCompensation: plugin is not trusted");
        require(_sender != address(0) , "GasCompensation: _sender is zero");
    }
}
