// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../../utils/CloneFactory.sol";
import "../../community/CommunityBlank.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../interfaces/IExecutePlugin.sol";
import "../PluginsList.sol";
import "../../libraries/DataTypes.sol";


contract Create is IExecutePlugin, Ownable, CloneFactory {

    uint256 private constant PLUGIN_VERSION = 1;
    bytes32 public PLUGIN_NAME = PluginsList.COMMUNITY_CREATE;

    IRegistry public registry;

    // For first deploy of CommunityBlank contract
    address public blank;

    modifier onlyExecutor() {
        require(registry.executor() == _msgSender(), "Join: caller is not the executor");
        _;
    }

    constructor(address _registry, address _owner) {
        _transferOwnership(_owner);
        registry = IRegistry(_registry);
    }

    function version() external pure returns (uint256) {
        return PLUGIN_VERSION;
    }

    function setBlank(address _blank) external onlyOwner {
        blank = _blank;
    }

    function execute(
        bytes32 _executedId,
        uint256 _version,
        address _sender,
        bytes calldata _data
    ) external override onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (string memory _name, bool _isInitial) = abi.decode(_data,(string, bool));
        address createdCommunity = createCommunity(_name, _sender, _isInitial);

        DataTypes.SimpleVars memory vars;
        vars.executedId = _executedId;
        vars.pluginName = PLUGIN_NAME;
        vars.version = PLUGIN_VERSION;
        vars.data = abi.encode(createdCommunity);

        require(
            ICommunityData(registry.communityData()).addCommunity(vars),
            "Create: wrong create community"
        );

        return true;
    }

    function createCommunity(string memory _name, address _creator, bool _isInitial) private returns(address) {
        CommunityBlank cb = blank == address(0) ?
        new CommunityBlank() :
        CommunityBlank(createClone(blank));
        cb.initialize(_name, address(registry), _creator, _isInitial);
        return address(cb);
    }

    function checkData(uint256 _version, address _sender) private view {
        require(_version == PLUGIN_VERSION, "Create: wrong _version");
        require(registry.isEnablePlugin(PLUGIN_NAME, PLUGIN_VERSION),"Create: plugin is not trusted");
        require(_sender != address(0) , "Create: _sender is zero");
    }
}
