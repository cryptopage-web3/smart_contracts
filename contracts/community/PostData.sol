// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../libraries/Sets.sol";
import "./interfaces/IPostData.sol";
import "../tokens/nft/interfaces/INFT.sol";


contract PostData is Initializable, ContextUpgradeable, IPostData {

    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;

    struct Metadata {
        string ipfsHash;
        string category;
        string[] tags;
        address creator;
        address repostFromCommunity;
        uint64 upCount;
        uint64 downCount;
        uint256 price;
        uint256 encodingType;
        uint256 timestamp;
        EnumerableSetUpgradeable.AddressSet upDownUsers;
        bool isView;
    }

    IRegistry public registry;
    INFT public nft;

    //postId -> communityId
    mapping(uint256 => address) private communityIdByPostId;
    //postId -> Metadata
    mapping(uint256 => Metadata) private posts;

    event WritePost(bytes32 executedId, uint256 postId, address creator, address owner);
    event BurnPost(bytes32 executedId, uint256 postId, address sender);

    event UpdateUpDown(bytes32 executedId, uint256 postId, address sender, bool isUp, bool isDown);
    event SetVisibility(bytes32 executedId, uint256 postId, bool isView);

    modifier onlyWritePostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_WRITE_POST, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "PostData: caller is not the plugin"
        );
        _;
    }

    modifier onlyBurnPostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_BURN_POST, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "PostData: caller is not the plugin"
        );
        _;
    }

    modifier onlyReadPostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_READ_POST, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "PostData: caller is not the plugin"
        );
        _;
    }

    modifier onlySetVisibilityPostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_VISIBILITY_POST, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "PostData: caller is not the plugin"
        );
        _;
    }

    modifier onlyWriteCommentPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_WRITE_COMMENT, "CommentData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "CommentData: caller is not the plugin"
        );
        _;
    }

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    //constructor() initializer {}

    function initialize(address _registry) external initializer {
        registry = IRegistry(_registry);
        nft = INFT(registry.nft());
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function ipfsHashOf(uint256 tokenId) external override view returns (string memory) {
        return posts[tokenId].ipfsHash;
    }

    function writePost(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external override onlyWritePostPlugin(_pluginName, _version) returns(uint256) {
        (address _communityId, address _owner, string memory _ipfsHash, uint256 _encodingType, string[] memory _tags) =
            abi.decode(_data,(address, address, string, uint256, string[]));

        uint256 postId = nft.mint(_owner);
        require(postId > 0, "PostData: wrong postId");
        communityIdByPostId[postId] = _communityId;

        Metadata storage post = posts[postId];
        post.creator = _sender;
        post.ipfsHash = _ipfsHash;
        post.timestamp = block.timestamp;
        post.encodingType = _encodingType;
        post.tags = _tags;
        post.isView = true;
        emit WritePost(_executedId, postId, _sender, _owner);

        return postId;
    }

    function burnPost(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external override onlyBurnPostPlugin(_pluginName, _version) returns(bool) {
        (uint256 _postId) =
        abi.decode(_data,(uint256));
        require(_postId > 0, "PostData: wrong postId");

        Metadata storage post = posts[_postId];
        post.ipfsHash = "";
        post.isView = false;
        emit BurnPost(_executedId, _postId, _sender);

        return true;
    }

    function setVisibility(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        bytes memory _data
    ) external override onlySetVisibilityPostPlugin(_pluginName, _version) returns(bool) {
        (uint256 _postId, bool _isView) =
        abi.decode(_data,(uint256, bool));

        Metadata storage post = posts[_postId];
        post.isView = _isView;
        emit SetVisibility(_executedId, _postId, _isView);

        return true;
    }

    function setPrice(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _price
    ) external override onlyWritePostPlugin(_pluginName, _version) returns(bool) {
        Metadata storage post = posts[_postId];
        post.price = _price;

        return true;
    }

    function updatePostWhenNewComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external override onlyWriteCommentPlugin(_pluginName, _version) returns(bool) {
        ( , uint256 _postId, , , bool _isUp, bool _isDown, ) =
        abi.decode(_data,(address, uint256, address, string, bool, bool, bool));

        setPostUpDown(_postId, _isUp, _isDown, _sender);
        emit UpdateUpDown(_executedId, _postId, _sender, _isUp, _isDown);

        return true;
    }

    function readPost(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId
    ) external view override onlyReadPostPlugin(_pluginName, _version) returns(
        bytes memory _data
    ) {
        Metadata storage post = posts[_postId];
        if(post.isView) {
            _data = abi.encode(
                post.ipfsHash,
                post.category,
                post.tags,
                post.creator,
                post.repostFromCommunity,
                post.upCount,
                post.downCount,
                post.price,
                post.encodingType,
                post.timestamp,
                post.upDownUsers.values(),
                true
            );
        }
    }

    function getCommunityId(uint256 _postId) external view override returns(address) {
        return communityIdByPostId[_postId];
    }

    function setPostUpDown(uint256 _postId, bool _isUp, bool _isDown, address _sender) private {
        if (!_isUp && !_isDown) {
            return;
        }
        require(!(_isUp && _isUp == _isDown), "PostData: wrong values for Up/Down");
        require(!isUpDownUser(_postId, _sender), "PostData: wrong user for Up/Down");

        Metadata storage curPost = posts[_postId];
        if (_isUp) {
            curPost.upCount++;
        }
        if (_isDown) {
            curPost.downCount++;
        }
        curPost.upDownUsers.add(_sender);
    }

    function isUpDownUser(uint256 _postId, address _user) public view returns(bool) {
        return posts[_postId].upDownUsers.contains(_user);
    }
}
