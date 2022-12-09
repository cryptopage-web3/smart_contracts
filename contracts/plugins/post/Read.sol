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
import "../../rules/community/interfaces/IPostPlacingRules.sol";


contract Read is Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_READ_POST;

    IRegistry public registry;

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function execute(
        bytes calldata _inData
    ) external view returns(bytes memory _outData) {
        address sender = _msgSender();

        (address _communityId , uint256 _postId) =
        abi.decode(_inData,(address, uint256));

        address groupRules = IRule(registry.rule()).getRuleContract(
            RulesList.POST_READING_RULES,
            PLUGIN_VERSION
        );
        require(
            IPostPlacingRules(groupRules).validate(_communityId, sender),
            "Write: wrong validate"
        );

        _outData = IPostData(registry.postData()).readPost(
            PLUGIN_NAME,
            PLUGIN_VERSION,
            _postId
        );
    }
}
