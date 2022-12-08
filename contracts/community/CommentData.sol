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

    event WriteComment(bytes32 executedId, uint256 postId, uint256 commentId, address creator, address owner);

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
    ) external override onlyWriteCommentPlugin(_pluginName, _version) returns(uint256) {
        uint256 beforeGas = gasleft();
        ( , uint256 _postId, address _owner, string memory _ipfsHash, bool _up, bool _down, bool _isView) =
        abi.decode(_data,(address, uint256, address, string, bool, bool, bool));
        require(_postId > 0, "Write: wrong postId");

        uint256 count = commentCount[_postId]++;

        Metadata storage comment = comments[_postId][count];
        comment.creator = _sender;
        comment.owner = _owner;
        comment.ipfsHash = _ipfsHash;
        comment.timestamp = block.timestamp;
        comment.up = _up;
        comment.down = _down;
        comment.isView = _isView;
        comment.price = beforeGas - gasleft();
        //emit WriteComment(_executedId, _postId, count, _sender, _owner);

        return count;
    }

    function setPrice(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId,
        uint256 _price
    ) external override onlyWriteCommentPlugin(_pluginName, _version) returns(bool) {
        Metadata storage comment = comments[_postId][_commentId];
        comment.price = _price;

        return true;
    }

    function readComment(uint256 _postId, uint256 _commentId) external view override returns(
        string memory ipfsHash,
        address creator,
        address owner,
        uint256 price,
        uint256 timestamp,
        bool up,
        bool down,
        bool isView
    ) {
        Metadata storage comment = comments[_postId][_commentId];
        if (comment.isView) {
            ipfsHash = comment.ipfsHash;
            creator = comment.creator;
            owner = comment.owner;
            price = comment.price;
            timestamp = comment.timestamp;
            up = comment.up;
            down = comment.down;
            isView = true;
        }
    }
}
