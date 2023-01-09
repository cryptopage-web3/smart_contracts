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
import "../../libraries/DataTypes.sol";


contract Write is IExecutePlugin, Context{

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
    ) external override onlyExecutor returns(bool) {
        uint256 beforeGas = gasleft();
        DataTypes.GeneralVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.user = _sender;
        vars.data = _data;

        checkData(_version, _sender);
        (address _communityId , , , , , , ) =
        abi.decode(_data,(address, address, string, uint256, string[], bool, bool));
        require(IAccount(registry.account()).isCommunityUser(_communityId, _sender), "Write: wrong _sender");

        checkRule(RulesList.USER_VERIFICATION_RULES, _communityId, _sender);
        checkRule(RulesList.POST_PLACING_RULES, _communityId, _sender);

        uint256 postId = IPostData(registry.postData()).writePost(
            vars
        );
        require(postId > 0, "Write: wrong create post");

        require(IAccount(registry.account()).addCreatedPostIdForUser(
                _executedId,
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _communityId,
                _sender,
                postId
            ),
            "Write: wrong added postId for user"
        );

        require(ICommunityData(registry.communityData()).addCreatedPostIdForCommunity(
                _executedId,
                PLUGIN_NAME,
                PLUGIN_VERSION,
                _communityId,
                postId
            ),
            "Write: wrong added postId for community"
        );

        uint256 gasConsumption = beforeGas - gasleft();
        require(
            IPostData(registry.postData()).setGasConsumption(
                PLUGIN_NAME,
                PLUGIN_VERSION,
                postId,
                    gasConsumption
            ),
            "Write: wrong set gasConsumption"
        );

    return true;
    }

    function checkRule(bytes32 _groupRulesName, address _communityId, address _sender) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRules(rulesContract).validate(_communityId, _sender),
            "Write: wrong rules validate"
        );
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Write: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Write: plugin is not trusted");
        require(_sender != address(0) , "Write: _sender is zero");
    }
}
