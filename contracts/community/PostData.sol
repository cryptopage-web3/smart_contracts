// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../libraries/Sets.sol";
import "./interfaces/IPostData.sol";
import "../tokens/nft/interfaces/INFT.sol";
import "../libraries/DataTypes.sol";


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
        uint256 gasConsumption;
        uint256 encodingType;
        uint256 timestamp;
        EnumerableSetUpgradeable.AddressSet upDownUsers;
        bool isEncrypted;
        bool isView;
    }

    IRegistry public registry;
    INFT public nft;

    //postId -> communityId
    mapping(uint256 => address) private communityIdByPostId;
    //postId -> Metadata
    mapping(uint256 => Metadata) private posts;
    //postId -> bool
    mapping(uint256 => bool) private gasCompensation;

    event WritePost(bytes32 executedId, uint256 postId);
    event BurnPost(bytes32 executedId, uint256 postId, address sender);

    event UpdateUpDown(bytes32 executedId, uint256 postId, address sender, bool isUp, bool isDown);
    event SetVisibility(bytes32 executedId, uint256 postId, bool isView);
    event SetGasCompensation(bytes32 executedId, uint256 postId);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
            "PostData: caller is not the plugin"
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
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_POST, vars.pluginName, vars.version) returns(uint256) {
        (
        address _communityId,
        address _owner,
        string memory _ipfsHash,
        uint256 _encodingType,
        string[] memory _tags,
        bool _isEncrypted,
        bool _isView
        ) = abi.decode(vars.data,(address, address, string, uint256, string[], bool, bool));

        uint256 postId = nft.mint(_owner);
        require(postId > 0, "PostData: wrong postId");
        communityIdByPostId[postId] = _communityId;

        Metadata storage post = posts[postId];
        post.creator = vars.user;
        post.ipfsHash = _ipfsHash;
        post.timestamp = block.timestamp;
        post.encodingType = _encodingType;
        post.tags = _tags;
        post.isEncrypted = _isEncrypted;
        post.isView = _isView;
        emit WritePost(vars.executedId, postId);

        return postId;
    }

    function burnPost(
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_BURN_POST, vars.pluginName, vars.version) returns(bool) {
        (uint256 _postId) =
        abi.decode(vars.data,(uint256));
        require(_postId > 0, "PostData: wrong postId");

        Metadata storage post = posts[_postId];
        post.ipfsHash = "";
        post.isView = false;
        emit BurnPost(vars.executedId, _postId, vars.user);

        return true;
    }

    function setVisibility(
        DataTypes.SimpleVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_CHANGE_VISIBILITY_POST, vars.pluginName, vars.version) returns(bool) {
        (uint256 _postId, bool _isView) =
        abi.decode(vars.data,(uint256, bool));

        Metadata storage post = posts[_postId];
        post.isView = _isView;
        emit SetVisibility(vars.executedId, _postId, _isView);

        return true;
    }

    function setGasCompensation(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_POST_GAS_COMPENSATION, _pluginName, _version) returns(
        uint256 gasConsumption,
        address creator
    ) {
        require(_postId > 0, "PostData: wrong postId");

        Metadata storage post = posts[_postId];
        gasConsumption = post.gasConsumption;
        creator = post.creator;
        require(!gasCompensation[_postId], "PostData: wrong gas compensation");
        gasCompensation[_postId] = true;

        emit SetGasCompensation(_executedId, _postId);
    }

    function setGasConsumption(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _gas
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_POST, _pluginName, _version) returns(bool) {
        Metadata storage post = posts[_postId];
        post.gasConsumption = _gas;

        return true;
    }

    function updatePostWhenNewComment(
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, vars.pluginName, vars.version) returns(bool) {
        ( , uint256 _postId, , , bool _isUp, bool _isDown, ) =
        abi.decode(vars.data,(address, uint256, address, string, bool, bool, bool));

        setPostUpDown(_postId, _isUp, _isDown, vars.user);
        emit UpdateUpDown(vars.executedId, _postId, vars.user, _isUp, _isDown);

        return true;
    }

    function readPost(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId
    ) external view override onlyTrustedPlugin(PluginsList.COMMUNITY_READ_POST, _pluginName, _version) returns(
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
                post.gasConsumption,
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
