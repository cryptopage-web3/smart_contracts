// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/ISoulBound.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../plugins/PluginsList.sol";
import "../../libraries/DataTypes.sol";


/// @title Contract of Page.SoulBound
/// @author Crypto.Page Team
/// @notice
/// @dev
contract SoulBound is
    Initializable,
    ContextUpgradeable,
    ERC1155Upgradeable,
    ISoulBound
{

    IRegistry public registry;

    event Mint(bytes32 executedId, address indexed user, uint256 id, uint256 amount);
    event Burn(bytes32 executedId, address indexed user, uint256 id, uint256 amount);
    event MintBatch(bytes32 executedId, address indexed user, uint256[] ids, uint256[] amounts);
    event BurnBatch(bytes32 executedId, address indexed user, uint256[] ids, uint256[] amounts);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "SoulBound: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "SoulBound: caller is not the plugin"
        );
        _;
    }

    function initialize(
        address _registry
    ) external initializer {
        require(_registry != address(0), "SoulBound: address cannot be zero");
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function mint(
        DataTypes.SoulBoundMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.SOULBOUND_GENERATE, vars.pluginName, vars.version) {
        require(vars.id > 0, "SoulBound: id cannot be zero");
        bytes memory data = new bytes(0);
        emit Mint(vars.executedId, vars.user, vars.id, vars.amount);
        _mint(vars.user, vars.id, vars.amount, data);
    }

    function burn(
        DataTypes.SoulBoundMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.SOULBOUND_BURN, vars.pluginName, vars.version) {
        require(vars.id > 0, "SoulBound: id cannot be zero");
        emit Burn(vars.executedId, vars.user, vars.id, vars.amount);
        _burn(vars.user, vars.id, vars.amount);
    }

    function mintBatch(
        DataTypes.SoulBoundBatchMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.SOULBOUND_GENERATE, vars.pluginName, vars.version) {
        bytes memory data = new bytes(0);
        emit MintBatch(vars.executedId, vars.user, vars.ids, vars.amounts);
        _mintBatch(vars.user, vars.ids, vars.amounts, data);
    }

    function burnBatch(
        DataTypes.SoulBoundBatchMintBurn calldata vars
    ) external override virtual onlyTrustedPlugin(PluginsList.SOULBOUND_BURN, vars.pluginName, vars.version) {
        emit BurnBatch(vars.executedId, vars.user, vars.ids, vars.amounts);
        _burnBatch(vars.user, vars.ids, vars.amounts);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(
        IERC165Upgradeable,
        ERC1155Upgradeable
    ) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(ERC1155Upgradeable) {
        if (operator != address(0) && from != address(0)) {
            revert("SoulBound: rejected transferring tokens");
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
