// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "./interfaces/ICommentData.sol";


contract CommentData is Initializable, ContextUpgradeable, ICommentData {

    struct Metadata {
        string ipfsHash;
        address creator;
        address owner;
        uint256 price;
        uint256 timestamp;
        bool up;
        bool down;
        bool isView;
    }

    IRegistry public registry;

    //postId -> commentId -> Metadata
    mapping(uint256 => mapping(uint256 => Metadata)) private comments;

    //postId -> comment counter
    mapping(uint256 => uint256) private commentCount;

//    event WriteComment(bytes32 executedId, uint256 postId, uint256 commentId, address creator, address owner);
    event WriteComment(bytes32 executedId, uint256 postId, uint256 commentId);
    event BurnComment(bytes32 executedId, uint256 postId, uint256 commentId, address sender);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "Account: wrong plugin name");
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
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function ipfsHashOf(uint256 _postId, uint256 _commentId) external override view returns (string memory) {
        return comments[_postId][_commentId].ipfsHash;
    }

    function writeComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, _pluginName, _version) returns(uint256) {
        ( , uint256 _postId, address _owner, string memory _ipfsHash, bool _up, bool _down, bool _isView) =
        abi.decode(_data,(address, uint256, address, string, bool, bool, bool));
        require(_postId > 0, "CommentData: wrong postId");

        uint256 count = commentCount[_postId]++;

        Metadata storage comment = comments[_postId][count];
        comment.creator = _sender;
        comment.owner = _owner;
        comment.ipfsHash = _ipfsHash;
        comment.timestamp = block.timestamp;
        comment.up = _up;
        comment.down = _down;
        comment.isView = _isView;
//        emit WriteComment(_executedId, _postId, count, _sender, _owner);
        //emit WriteComment(_executedId, _postId, count);

        return count;
    }

    function burnComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_BURN_COMMENT, _pluginName, _version) returns(bool) {
        (uint256 _postId, uint256 _commentId) =
        abi.decode(_data,(uint256, uint256));

        Metadata storage comment = comments[_postId][_commentId];
        require(comment.timestamp > 0, "CommentData: wrong postId");

        comment.ipfsHash = "";
        comment.isView = false;

        emit BurnComment(_executedId, _postId, _commentId, _sender);

        return true;
    }

    function setPrice(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId,
        uint256 _price
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, _pluginName, _version) returns(bool) {
        Metadata storage comment = comments[_postId][_commentId];
        comment.price = _price;

        return true;
    }

    function readComment(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId
    ) external view override onlyTrustedPlugin(PluginsList.COMMUNITY_READ_COMMENT, _pluginName, _version) returns(
        bytes memory _data
    ) {
        Metadata storage comment = comments[_postId][_commentId];
        if (comment.isView) {
            _data = abi.encode(
                comment.ipfsHash,
                comment.creator,
                comment.owner,
                comment.price,
                comment.timestamp,
                comment.up,
                comment.down,
                true
            );
        }
    }
}
