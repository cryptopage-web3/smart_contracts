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

    address public registry;

    Counter32bytes.Counter public idCounter;

    string public baseTokenURI;

    struct CommentMetadata {
        string ipfsHash;
        address creator;
        address owner;
        uint256 price;
        bool up;
        bool down;
        bool visible;
    }

    struct PostMetadata {
        string ipfsHash;
        string category;
        address creator;
        bool visible;
        bool repostable;
        uint64 upCount;
        uint64 downCount;
        uint256 price;
        uint256 commentCount;
        uint256 encodingType;
        Sets.StringSet tags;
        // commentId -> CommentMetadata
        mapping(uint256 => CommentMetadata) comments;
        mapping(address => EnumerableSetUpgradeable.UintSet) user2comments;
    }

    // tokenId -> PostMetadata
    mapping(uint256 => PostMetadata) internal posts;

    // userAddress -> pluginId
    mapping(address => uint16) public usersPluginReceive;

    function initialize(
        address _registry,
        uint8 _blockchainId,
        string memory _baseTokenURI
    ) external initializer {
        __ERC721_init("Crypto.Page NFT", "PAGE.NFT");
        registry = _registry;
        baseTokenURI = _baseTokenURI;
        idCounter.set(_blockchainId, 1);
    }

    function version() external pure returns (string memory) {
        return "1";
    }

    function setBaseTokenURI(string memory _baseTokenURI) external override onlyRole(TOKEN_URL_MANAGER_ROLE) {
        baseTokenURI = _baseTokenURI;
    }

    function mint(
        address owner,
        uint256 tokenId
    ) external override onlyRole(MINTER_ROLE) returns (uint256) {
        _mint(owner, tokenId);
        return tokenId;
    }

    function mint(
        address _creator,
//        address _owner,
        bool _repostable,
        uint256 _encodingType,
        string memory _ipfsHash,
        string memory _category,
        string[] memory tags
    ) external override returns (uint256) {
        uint256 gas = gasleft();

        uint256 tokenId = idCounter.current();
//        bool community = isCommunity(_owner);

//        receivePluginMint(_owner, tokenId);

        PostMetadata storage post = posts[tokenId];
        post.ipfsHash = _ipfsHash;
        post.creator = _creator;
        post.visible = true;
        post.repostable = _repostable;
        post.encodingType = _encodingType;
        post.category = _category;
        post.tags._values = tags;

//        community ? communityAssignToken(_owner, tokenId) : accountAssignToken(_owner, tokenId);
        idCounter.increment();

        gas = gas - gasleft();
        post.price = gas;

        return tokenId;
    }

    function burn(uint256 tokenId) external override {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        require(owner == _msgSender(), "NFT: not owner");

        PostMetadata storage post = posts[tokenId];
        post.visible = false;
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
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, posts[tokenId].ipfsHash)) : "";
    }

    function ipfsHashOf(uint256 tokenId) external override view returns (string memory) {
        return posts[tokenId].ipfsHash;
    }

    function _requireMinted(uint256 tokenId) internal override view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

//    function accountAssignToken(address _owner, uint256 _tokenId) private {
//        IRegistry reg = IRegistry(registry);
//        uint16 accountId = reg.getId("Page.PersonalAccount");
//        IAccount account = IAccount(reg.getLayer2(accountId));
//        //account.assignToken(_owner, _tokenId);
//    }

//    function communityAssignToken(address _owner, uint256 _tokenId) private {
//        IRegistry reg = IRegistry(registry);
//        uint16 communityId = reg.getId("Page.Community");
//        ICommunity community = ICommunity(reg.getLayer2(communityId));
//        community.assignToken(_owner, _tokenId);
//    }

//    function receivePluginMint(address _owner, uint256 tokenId) private {
//        IRegistry reg = IRegistry(registry);
//        uint16 nftId = reg.getId("Page.NFT");
//        uint16 pluginId = usersPluginReceive[_owner];
//        IReceivePlugin receivePlugin = IReceivePlugin(reg.getPlugin(nftId, pluginId));
//        receivePlugin.mint(address(this), _msgSender(), _owner, tokenId);
//    }

//    function isCommunity(address _owner) private view returns(bool) {
//        IRegistry reg = IRegistry(registry);
//        uint16 communityId = reg.getId("Page.Community");
//        return ICommunity(reg.getLayer2(communityId)).isCommunity(_owner);
//    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721EnumerableUpgradeable, IERC165Upgradeable, AccessControlUpgradeable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
