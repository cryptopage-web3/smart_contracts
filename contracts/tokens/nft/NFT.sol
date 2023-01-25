// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/INFT.sol";
import "../../registry/interfaces/IRegistry.sol";
import "../../account/interfaces/IAccount.sol";
import "../../community/interfaces/ICommunityData.sol";

import "./libraries/Counter32bytes.sol";
import "../../libraries/Sets.sol";

/// @title Contract of Page.NFT
/// @author Crypto.Page Team
/// @notice
/// @dev
contract NFT is
    AccessControlUpgradeable,
    ERC721EnumerableUpgradeable,
    INFT
{
    bytes32 public constant TOKEN_URL_MANAGER_ROLE = keccak256("TOKEN_URL_MANAGER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant TRANSFER_MANAGER_ROLE = keccak256("TRANSFER_MANAGER_ROLE");

    using Counter32bytes for Counter32bytes.Counter;
    using Sets for Sets.StringSet;

    IRegistry public registry;

    Counter32bytes.Counter public idCounter;

    string public baseTokenURI;

    modifier onlyPostData() {
        require(registry.postData() == _msgSender(), "NFT: caller is not the postData");
        _;
    }

    function initialize(
        address _registry,
        uint8 _blockchainId,
        string memory _baseTokenURI
    ) external initializer {
        __ERC721_init("Crypto.Page NFT", "PAGE.NFT");
        registry = IRegistry(_registry);
        baseTokenURI = _baseTokenURI;
        idCounter.set(_blockchainId, 1);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function setBaseTokenURI(string memory _baseTokenURI) external override onlyRole(TOKEN_URL_MANAGER_ROLE) {
        baseTokenURI = _baseTokenURI;
    }

    function mint(address _owner) external override onlyPostData returns (uint256) {
        uint256 tokenId = idCounter.current();
        _mint(_owner, tokenId);
        idCounter.increment();

        return tokenId;
    }

    function burn(uint256 tokenId) external override onlyPostData {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        require(owner == _msgSender(), "NFT: not owner");
        _burn(tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721Upgradeable, IERC721Upgradeable) onlyRole(TRANSFER_MANAGER_ROLE) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721Upgradeable, IERC721Upgradeable) onlyRole(TRANSFER_MANAGER_ROLE) {
        super.safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override(ERC721Upgradeable, IERC721Upgradeable) onlyRole(TRANSFER_MANAGER_ROLE) {
        super.safeTransferFrom(from, to, tokenId, _data);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable, INFT) returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = baseTokenURI;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId)) : "";
    }

    function _requireMinted(uint256 tokenId) internal override view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721EnumerableUpgradeable, IERC165Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
