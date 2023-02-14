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
import "../interfaces/IReadPlugin.sol";
import "../../libraries/DataTypes.sol";


contract Info is IReadPlugin, Context {
    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_USER_INFO;

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

        (address _user) =
        abi.decode(_inData,(address));

        address[] memory communities = IAccount(registry.account()).getCommunitiesByUser(_user);

        DataTypes.UserRateCount memory rate = IAccount(registry.account()).getAllCommunitiesUserRate(_user);

        uint256[] memory postIds = IAccount(registry.account()).getAllPostIdsByUser(_user);

        _outData = abi.encode(communities, rate.postCount, rate.commentCount, rate.upCount, rate.downCount, postIds);
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Info: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Info: plugin is not trusted");
        require(_sender != address(0) , "Info: _sender is zero");
    }
}
