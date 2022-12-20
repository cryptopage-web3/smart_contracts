// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../community/interfaces/ICommunityBlank.sol";
import "../../registry/interfaces/IRegistry.sol";

import "../../rules/interfaces/IRule.sol";
import "../../rules/community/RulesList.sol";
import "../PluginsList.sol";
import "../interfaces/IReadPlugin.sol";
import "../../rules/community/interfaces/IPostPlacingRules.sol";


contract Info is IReadPlugin, Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_INFO;

    IRegistry public registry;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Info: caller is not the executor");
        _;
    }

    constructor(address _registry) {
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function read(
        uint256 _version,
        address _sender,
        bytes calldata _inData
    ) external override onlyExecutor view returns(bytes memory _outData) {
        checkData(_version, _sender);
        (address _communityId) =
        abi.decode(_inData,(address));

        string memory name = ICommunityBlank(_communityId).name();
        address creator = ICommunityBlank(_communityId).creator();
        address owner = Ownable(_communityId).owner();
        uint256 creatingTime = ICommunityBlank(_communityId).creatingTime();

        uint256[] memory postIds = ICommunityData(registry.communityData()).getPostIds(_communityId);
        (
            address[] memory normalUsers,
            address[] memory bannedUsers,
            address[] memory moderators
        ) = IAccount(registry.account()).getCommunityUsers(_communityId);

        _outData = abi.encode(name, creator, owner, creatingTime, normalUsers, bannedUsers, moderators, postIds);
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Info: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Info: plugin is not trusted");
        require(_sender != address(0) , "Info: _sender is zero");
    }
}
