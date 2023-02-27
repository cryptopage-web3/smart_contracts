// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

import "./interfaces/INFT.sol";
import "../../registry/interfaces/IRegistry.sol";
import "./libraries/Counter32bytes.sol";

/// @title Contract of Page.NFT
/// @author Crypto.Page Team
/// @notice
/// @dev
contract NFT is
    OwnableUpgradeable,
    ERC721EnumerableUpgradeable,
    INFT
{

    using Counter32bytes for Counter32bytes.Counter;

    IRegistry public registry;
    Counter32bytes.Counter public idCounter;
    string public baseTokenURI;
    mapping(uint256 => address) private _tokenReceiveApprovals;

    event ReceiveApproval(address owner, address to, uint256 tokenId);

    modifier onlyPostData() {
        require(registry.postData() == _msgSender(), "Crypto.Page NFT: caller is not the postData");
        _;
    }

    function initialize(
        address _registry,
        uint8 _blockchainId,
        string memory _baseTokenURI
    ) external initializer {
        __Ownable_init();
        __ERC721_init("Crypto.Page NFT", "PAGE.NFT");
        registry = IRegistry(_registry);
        baseTokenURI = _baseTokenURI;
        idCounter.set(_blockchainId, 1);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function setBaseTokenURI(string memory _baseTokenURI) external override onlyOwner {
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
        require(owner == _msgSender(), "Crypto.Page NFT: not owner");
        _burn(tokenId);
    }

    function setReceiveApproved(address to, uint256 tokenId) external override {
        address owner = super.ownerOf(tokenId);
        require(to != owner, "Crypto.Page NFT: receive approval to current owner");

        require(
            _msgSender() == owner || super.isApprovedForAll(owner, _msgSender()),
            "Crypto.Page NFT: receive approve caller is not token owner nor approved for all"
        );
        _tokenReceiveApprovals[tokenId] = to;
        emit ReceiveApproval(owner, to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721Upgradeable, INFT) returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = baseTokenURI;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId)) : "";
    }

    function getReceiveApproved(uint256 tokenId) public view override returns (address) {
        super._requireMinted(tokenId);
        return _tokenReceiveApprovals[tokenId];
    }

    function tokensOfOwner(address user) external override view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(user);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory output = new uint256[](tokenCount);
            for (uint256 index = 0; index < tokenCount; index++) {
                output[index] = tokenOfOwnerByIndex(user, index);
            }
            return output;
        }
    }

    function _requireMinted(uint256 tokenId) internal override view virtual {
        require(_exists(tokenId), "Crypto.Page NFT: invalid token ID");
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721EnumerableUpgradeable, IERC165Upgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        if (from != address(0) && to != address(0)) {
            require(getReceiveApproved(tokenId) == to, "Crypto.Page NFT: wrong receive approved");
            _tokenReceiveApprovals[tokenId] = address(0);
        }
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
