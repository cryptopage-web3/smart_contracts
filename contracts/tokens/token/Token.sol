// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import "./interfaces/IToken.sol";
import "../../registry/interfaces/IRegistry.sol";

/// @title Contract of Page.Token
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Token is IToken, ERC20Upgradeable {

    IRegistry public registry;

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Bank: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "Bank: caller is not the plugin"
        );
        _;
    }

    function initialize(address _registry) external initializer {
        __ERC20_init("Page.Token", "PAGE");

        require(_registry != address(0), "Token: address cannot be zero");
        registry = IRegistry(_registry);

        address treasury = registry.treasury();
        _mint(treasury, 5e7);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

//    function mint(address to, uint256 amount) public override onlyRole(MINT_ROLE) {
//        require(to != address(0), "Token: address cannot be zero");
//        _mint(to, amount);
//    }
//
//    function burn(address to, uint256 amount) public override onlyRole(BURN_ROLE) {
//        require(to != address(0), "Token: address cannot be zero");
//        _burn(to, amount);
//    }
}
