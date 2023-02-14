// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IExecutePlugin.sol";
import "../../rules/community/interfaces/IBaseRules.sol";
import "../../rules/community/interfaces/IBaseRulesWithPostId.sol";
import "../../libraries/DataTypes.sol";


contract RePost is IExecutePlugin, Context{

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_REPOST;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "RePost: caller is not the executor");
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

        DataTypes.GeneralVars memory postVars;
        postVars.executedId = _executedId;
        postVars.pluginName = PLUGIN_NAME;
        postVars.version = PLUGIN_VERSION;
        postVars.user = _sender;

        DataTypes.MinSimpleVars memory gasVars;
        gasVars.pluginName = PLUGIN_NAME;
        gasVars.version = PLUGIN_VERSION;

        checkData(_version, _sender);

        (address _userCommunityId , uint256 _postId) =
        abi.decode(_data,(address, uint256));

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(_postId);
        DataTypes.PostInfo memory outData = IPostData(registry.postData()).readPost(vars);

        postVars.data = abi.encode(
            _userCommunityId, _sender, outData.ipfsHash, outData.encodingType, outData.tags, outData.isEncrypted, true
        );

        require(IAccount(registry.account()).isCommunityUser(_userCommunityId, _sender), "RePost: wrong _sender");

        checkRuleWithPostId(RulesList.POST_TRANSFERRING_RULES, _userCommunityId, _sender, _postId);
        checkBaseRule(RulesList.USER_VERIFICATION_RULES, _userCommunityId, _sender);
        checkBaseRule(RulesList.POST_PLACING_RULES, _userCommunityId, _sender);

        uint256 postId = IPostData(registry.postData()).writePost(postVars);
        require(postId > 0, "RePost: wrong create post");

        bytes memory newData = abi.encode(_userCommunityId, postId);
        postVars.data = newData;

        require(IAccount(registry.account()).addCreatedPostIdForUser(postVars),
            "RePost: wrong added postId for user"
        );

        require(ICommunityData(registry.communityData()).addCreatedPostIdForCommunity(postVars),
            "RePost: wrong added postId for community"
        );

        uint256 gasConsumption = beforeGas - gasleft();
        bytes memory gasData = abi.encode(postId, gasConsumption);
        gasVars.data = gasData;
        require(
            IPostData(registry.postData()).setGasConsumption(gasVars),
            "RePost: wrong set gasConsumption"
        );

        return true;
    }

    function checkBaseRule(bytes32 _groupRulesName, address _communityId, address _sender) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRules(rulesContract).validate(_communityId, _sender),
            "RePost: wrong base rules validate"
        );
    }

    function checkRuleWithPostId(bytes32 _groupRulesName, address _communityId, address _sender, uint256 _postId) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRulesWithPostId(rulesContract).validate(_communityId, _sender, _postId),
            "RePost: wrong rules with postId validate"
        );
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "RePost: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"RePost: plugin is not trusted");
        require(_sender != address(0) , "RePost: _sender is zero");
    }
}
