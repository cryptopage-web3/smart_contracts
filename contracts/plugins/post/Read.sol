// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/IPostData.sol";
import "../../community/interfaces/ICommentData.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../tokens/nft/interfaces/INFT.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../../rules/community/interfaces/IPostReadingRules.sol";
import "../../libraries/DataTypes.sol";


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

    function read(
        uint256 _postId
    ) external view returns(DataTypes.PostInfo memory outData) {
        address sender = _msgSender();
        address communityId = IPostData(registry.postData()).getCommunityId(_postId);

        checkPlugin(communityId);
        checkRule(RulesList.POST_READING_RULES, communityId, sender);

        DataTypes.MinSimpleVars memory vars;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(_postId);

        outData = IPostData(registry.postData()).readPost(vars);
        outData.communityId = communityId;
        outData.currentOwner = INFT(registry.nft()).ownerOf(_postId);
        outData.commentCount = ICommentData(registry.commentData()).getCommentCount(_postId);
    }

    function checkRule(bytes32 _groupRulesName, address _communityId, address _sender) private view {
        address rulesContract = IRule(registry.rule()).getRuleContract(
            _groupRulesName,
            PLUGIN_VERSION
        );
        require(
            IPostReadingRules(rulesContract).validate(_communityId, _sender),
            "Write: wrong rules validate"
        );
    }

    function checkPlugin(address _communityId) private view {
        (bool enable, address pluginContract) = registry.getPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(enable, "Info: wrong enable plugin");
        require(pluginContract != address(0), "Info: wrong plugin contract");

        bool isLinked = ICommunityBlank(_communityId).isLinkedPlugin(PLUGIN_NAME, PLUGIN_VERSION);
        require(isLinked, "Info: plugin is not linked for the community");
    }
}
