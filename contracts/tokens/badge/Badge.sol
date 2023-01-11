// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/IBadge.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../plugins/PluginsList.sol";
import "../../libraries/DataTypes.sol";


/// @title Contract of Page.Badge
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Badge is
    Initializable,
    ContextUpgradeable,
    ERC1155Upgradeable,
    IBadge
{

    IRegistry public registry;

    event Mint(bytes32 executedId, address indexed user, uint256 id, uint256 amount);
    event Burn(bytes32 executedId, address indexed user, uint256 id, uint256 amount);
    event MintBatch(bytes32 executedId, address indexed user, uint256[] ids, uint256[] amounts);
    event BurnBatch(bytes32 executedId, address indexed user, uint256[] ids, uint256[] amounts);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Badge: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "Badge: caller is not the plugin"
        );
        _;
    }

    function initialize(
        address _registry
    ) external initializer {
        require(_registry != address(0), "Badge: address cannot be zero");
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function mint(
        DataTypes.BadgeMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.BADGE_GENERATE, vars.pluginName, vars.version) {
        require(vars.id > 0, "Badge: id cannot be zero");
        bytes memory data = new bytes(0);
        emit Mint(vars.executedId, vars.user, vars.id, vars.amount);
        _mint(vars.user, vars.id, vars.amount, data);
    }

    function burn(
        DataTypes.BadgeMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.BADGE_BURN, vars.pluginName, vars.version) {
        require(vars.id > 0, "Badge: id cannot be zero");
        emit Burn(vars.executedId, vars.user, vars.id, vars.amount);
        _burn(vars.user, vars.id, vars.amount);
    }

    function mintBatch(
        DataTypes.BadgeBatchMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.BADGE_GENERATE, vars.pluginName, vars.version) {
        bytes memory data = new bytes(0);
        emit MintBatch(vars.executedId, vars.user, vars.ids, vars.amounts);
        _mintBatch(vars.user, vars.ids, vars.amounts, data);
    }

    function burnBatch(
        DataTypes.BadgeBatchMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.BADGE_BURN, vars.pluginName, vars.version) {
        emit BurnBatch(vars.executedId, vars.user, vars.ids, vars.amounts);
        _burnBatch(vars.user, vars.ids, vars.amounts);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(
        IERC165Upgradeable,
        ERC1155Upgradeable
    ) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
