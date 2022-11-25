// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";

import "../../utils/CloneFactory.sol";
import "../../community/CommunityBlank.sol";
import "../../community/interfaces/ICommunityData.sol";
import "../../plugins/interfaces/IAdrAdr.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";


contract Create is Ownable, CloneFactory {

    uint256 private constant PLUGIN_VERSION = 1;

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
        bytes calldata data
    ) external onlyExecutor returns(bool) {
        checkData(_version, _sender);
        (string memory _name, bool _isInitial) = abi.decode(data,(string, bool));
        address createdCommunity = createCommunity(_name, _sender, _isInitial);
        require(
            ICommunityData(registry.communityData()).addCommunity(
                _executedId,
                PluginsList.COMMUNITY_CREATE,
                _version,
                createdCommunity
            ),
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
        require(registry.isEnablePlugin(PluginsList.COMMUNITY_CREATE, _version),"Create: plugin is not trusted");
        require(_sender != address(0) , "Create: _sender is zero");
    }
}
