// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../registry/interfaces/IRegistry.sol";
import "./BasePlugin.sol";

import "../rules/community/interfaces/IBaseRules.sol";
import "../rules/community/interfaces/IBaseRulesWithPostId.sol";
import "../rules/interfaces/IRule.sol";


abstract contract BasePluginWithRules is BasePlugin {

    function checkBaseRule(bytes32 _groupRulesName, address _communityId, address _sender) internal view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRules(rulesContract).validate(_communityId, _sender),
            "BasePluginWithRules: wrong base rules validate"
        );
    }

    function checkRuleWithPostId(bytes32 _groupRulesName, address _communityId, address _sender, uint256 _postId) internal view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IBaseRulesWithPostId(rulesContract).validate(_communityId, _sender, _postId),
            "BasePluginWithRules: wrong rules with postId validate"
        );
    }
}
