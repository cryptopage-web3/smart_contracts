// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../libraries/DataTypes.sol";
import "../BasePluginWithRules.sol";


contract Write is IExecutePlugin, BasePluginWithRules {

    constructor(address _registry) {
        PLUGIN_VERSION = 1;
        PLUGIN_NAME = PluginsList.COMMUNITY_WRITE_POST;
        registry = IRegistry(_registry);
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        uint256 beforeGas = gasleft();

        DataTypes.GeneralVars memory postVars;
        postVars.executedId = _executedId;
        postVars.pluginName = PLUGIN_NAME;
        postVars.version = PLUGIN_VERSION;
        postVars.user = _sender;
        postVars.data = _data;

        DataTypes.MinSimpleVars memory gasVars;
        gasVars.pluginName = PLUGIN_NAME;
        gasVars.version = PLUGIN_VERSION;
        gasVars.data = _data;

        (address _communityId , address _repostFromCommunity, , , , , , ) =
        abi.decode(_data,(address, address, address, string, uint256, string[], bool, bool));
        checkPlugin(_version, _communityId);

        require(_repostFromCommunity == address(0), "Write: wrong _repostFromCommunity");
        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        checkBaseRule(RulesList.USER_VERIFICATION_RULES, _communityId, _sender);
        checkBaseRule(RulesList.POST_PLACING_RULES, _communityId, _sender);

        uint256 postId = IPostData(registry.postData()).writePost(postVars);
        require(postId > 0, "Write: wrong create post");

        bytes memory newData = abi.encode(_communityId, postId);
        postVars.data = newData;

        require(IAccount(registry.account()).addCreatedPostIdForUser(postVars),
            "Write: wrong added postId for user"
        );

        require(ICommunityData(registry.communityData()).addCreatedPostIdForCommunity(postVars),
            "Write: wrong added postId for community"
        );

        uint256 gasConsumption = beforeGas - gasleft();
        bytes memory gasData = abi.encode(postId, gasConsumption);
        gasVars.data = gasData;
        require(
            IPostData(registry.postData()).setGasConsumption(gasVars),
            "Write: wrong set gasConsumption"
        );

        return true;
    }
}
