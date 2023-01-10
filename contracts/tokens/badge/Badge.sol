// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/IBadge.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";

/// @title Contract of Page.Badge
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Badge is
    AccessControlUpgradeable,
    ERC1155Upgradeable,
    IBadge
{
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");

    IRegistry public registry;

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
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        require(_registry != address(0), "Token: address cannot be zero");
        registry = IRegistry(_registry);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external override virtual onlyTrustedPlugin(PluginsList.BADGE_GENERATE, _pluginName, _version)  {
        require(to != address(0), "Badge: address cannot be zero");
        _mint(to, id, amount, data);
    }

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) external override virtual onlyRole(BURN_ROLE) {
        require(account != address(0), "Badge: address cannot be zero");
        _burn(account, id, value);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external override virtual onlyRole(MINT_ROLE) {
        require(to != address(0), "Badge: address cannot be zero");
        _mintBatch(to, ids, amounts, data);
    }

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) external override virtual onlyRole(BURN_ROLE) {
        require(account != address(0), "Badge: address cannot be zero");
        _burnBatch(account, ids, values);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(
        IERC165Upgradeable,
        ERC1155Upgradeable,
        AccessControlUpgradeable
    ) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
