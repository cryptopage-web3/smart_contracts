// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/utils/Context.sol";

import "../../plugins/interfaces/IAdrAdr.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../PluginsList.sol";


contract Join is Context, IAdrAdr {

    address public community;
    IRegistry public registry;

    string private constant pluginVersion = "1";

    modifier onlyCommunity() {
        require(community == _msgSender(), "Join: caller is not the community");
        _;
    }

    constructor(address _community, address _registry) {
        community = _community;
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return pluginVersion;
    }

    function execute(
        uint256 _version,
        address _sender,
        address _communityId
    ) external view onlyCommunity {
        checkTrustToPlugin(_version);
        checkCommunity(_communityId);
        checkSender(_sender);
    }

    function checkTrustToPlugin(uint256 _version) private view {
        (bool trustToPlugin,,) = registry.getPlugin(PluginsList.COMMUNITY_JOIN, _version);
        require(trustToPlugin, "Join: plugin is not trusted");
    }

    function checkCommunity(address _communityId) private pure {
        require(_communityId != address(0) , "Join: _communityId is not zero");
    }
    function checkSender(address _sender) private pure {
        require(_sender != address(0) , "Join: _sender is not zero");
    }
}
