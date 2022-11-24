// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../../rules/community/interfaces/ICommunityJoiningRules.sol";
import "../PluginsList.sol";


contract Join is Context {

    uint256 private constant PLUGIN_VERSION = 1;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Join: caller is not the executor");
        _;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        uint256 _version,
        address _sender,
        bytes calldata data
    ) external onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (address _communityId) = abi.decode(data,(address));
        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.COMMUNITY_JOINING_RULES,
            PLUGIN_VERSION
        );
        require(
            ICommunityJoiningRules(groupRules).validate(_communityId, _sender),
            "Join: wrong validate"
        );
        require(
            IAccount(registry.account()).addCommunityUser(
                PluginsList.COMMUNITY_JOIN,
                _version,
                _communityId,
                _sender
            ),
            "Join: wrong create community"
        );

        return true;
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Join: wrong _version");
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_JOIN, _version),"Join: plugin is not trusted");
        require(_sender != address(0) , "Join: _sender is zero");
    }
}
