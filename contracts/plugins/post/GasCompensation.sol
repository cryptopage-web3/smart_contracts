// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../bank/interfaces/IBank.sol";
import "../../community/interfaces/IPostData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IGasCompensationRules.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../libraries/DataTypes.sol";
import "../../tokens/nft/interfaces/INFT.sol";
import "../BasePlugin.sol";

contract GasCompensation is IExecutePlugin, BasePlugin {

    uint256 public constant ALL_PERCENT = 10000;

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_POST_GAS_COMPENSATION;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address ,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        DataTypes.SimpleVars memory postVars;
        postVars.executedId = _executedId;
        postVars.pluginName = PLUGIN_NAME;
        postVars.version = PLUGIN_VERSION;

        DataTypes.GasCompensationBank memory bankVars;
        bankVars.executedId = _executedId;
        bankVars.pluginName = PLUGIN_NAME;
        bankVars.version = PLUGIN_VERSION;

        (uint256[] memory postIds) = abi.decode(_data,(uint256[]));

        for (uint256 i = 0; i < postIds.length; i++) {
            uint256 postId = postIds[i];
            bytes memory postData = abi.encode(postId);
            postVars.data = postData;
            address communityId = IPostData(registry.postData()).getCommunityId(postId);
            require(communityId != address(0), "GasCompensation: wrong community");
            checkPlugin(_version, communityId);

            (uint256 gas, address creator) = IPostData(registry.postData()).setGasCompensation(postVars);

            address owner = INFT(registry.nft()).ownerOf(postId);
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
                        IBank(registry.bank()).gasCompensation(bankVars),
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
        address _author,
        address _owner
    ) private view returns(address[] memory) {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        return IGasCompensationRules(rulesContract).validate(_communityId, _author, _owner);
    }
}
