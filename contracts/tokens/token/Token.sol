// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

import "./interfaces/IToken.sol";
import "../../registry/interfaces/IRegistry.sol";

/// @title Contract of Page.Token
/// @author Crypto.Page Team
/// @notice
/// @dev
contract Token is IToken, ERC20Upgradeable {

    uint256 public constant TOKEN_EMISSION = 50_000_000;

    IRegistry public registry;

    event Mint(address to, uint256 amount);
    event Burn(address from, uint256 amount);

    modifier onlyBank() {
        require(
            registry.bank() == _msgSender(),
            "Token: caller is not the bank"
        );
        _;
    }

    function initialize(address _registry) external initializer {
        __ERC20_init("Page.Token", "PAGE");

        require(_registry != address(0), "Token: address cannot be zero");
        registry = IRegistry(_registry);

        address treasury = registry.treasury();
        uint256 tokenAmount = TOKEN_EMISSION * uint256(10 ** decimals());
        _mint(treasury, tokenAmount);
        emit Mint(treasury, tokenAmount);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function mint(address _to, uint256 _amount) public override onlyBank returns(bool) {
        _mint(_to, _amount);
        emit Mint(_to, _amount);

        return true;
    }

    function burn(address _from, uint256 _amount) public override onlyBank returns(bool) {
        _burn(_from, _amount);
        emit Burn(_from, _amount);

        return true;
    }
}
