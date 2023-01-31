// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "./interfaces/ICommentData.sol";
import "../libraries/DataTypes.sol";


contract CommentData is Initializable, ContextUpgradeable, ICommentData {

    struct Metadata {
        string ipfsHash;
        address creator;
        address owner;
        uint256 gasConsumption;
        uint256 timestamp;
        bool up;
        bool down;
        bool isEncrypted;
        bool isView;
    }

    IRegistry public registry;

    //postId -> commentId -> Metadata
    mapping(uint256 => mapping(uint256 => Metadata)) private comments;

    //postId -> commentId -> bool
    mapping(uint256 => mapping(uint256 => bool)) private gasCompensation;

    //postId -> comment counter
    mapping(uint256 => uint256) private commentCount;

    event WriteComment(bytes32 executedId, uint256 postId, uint256 commentId);
    event BurnComment(bytes32 executedId, uint256 postId, uint256 commentId, address sender);
    event SetVisibility(bytes32 executedId, uint256 postId, uint256 commentId, bool isView);
    event SetGasCompensation(bytes32 executedId, uint256 postId, uint256 commentId);

    modifier onlyTrustedPlugin(bytes32 _trustedPluginName, bytes32 _checkedPluginName, uint256 _version) {
        require(_trustedPluginName == _checkedPluginName, "CommentData: wrong plugin name");
        require(
            registry.getPluginContract(_trustedPluginName, _version) == _msgSender(),
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
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, vars.pluginName, vars.version) returns(uint256) {
        ( , uint256 _postId, address _owner, string memory _ipfsHash, bool _up, bool _down, bool _isEncrypted, bool _isView) =
        abi.decode(vars.data,(address, uint256, address, string, bool, bool, bool, bool));
        require(_postId > 0, "CommentData: wrong postId");

        uint256 count = commentCount[_postId]++;

        Metadata storage comment = comments[_postId][count];
        comment.creator = vars.user;
        comment.owner = _owner;
        comment.ipfsHash = _ipfsHash;
        comment.timestamp = block.timestamp;
        comment.up = _up;
        comment.down = _down;
        comment.isEncrypted = _isEncrypted;
        comment.isView = _isView;
        emit WriteComment(vars.executedId, _postId, count);

        return count;
    }

    function burnComment(
        DataTypes.GeneralVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_BURN_COMMENT, vars.pluginName, vars.version) returns(bool) {
        (uint256 _postId, uint256 _commentId) =
        abi.decode(vars.data,(uint256, uint256));

        Metadata storage comment = comments[_postId][_commentId];
        require(comment.timestamp > 0, "CommentData: wrong postId");

        comment.ipfsHash = "";
        comment.isView = false;

        emit BurnComment(vars.executedId, _postId, _commentId, vars.user);

        return true;
    }

    function setVisibility(
        DataTypes.SimpleVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_CHANGE_VISIBILITY_COMMENT, vars.pluginName, vars.version) returns(bool) {
        (uint256 _postId, uint256 _commentId, bool _isView) =
        abi.decode(vars.data,(uint256, uint256, bool));

        Metadata storage comment = comments[_postId][_commentId];
        require(comment.timestamp > 0, "CommentData: wrong postId");

        comment.isView = _isView;
        emit SetVisibility(vars.executedId, _postId, _commentId, _isView);

        return true;
    }

    function setGasCompensation(
        DataTypes.GasCompensationComment calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_COMMENT_GAS_COMPENSATION, vars.pluginName, vars.version) returns(
        uint256 gasConsumption,
        address creator,
        address owner
    ) {
        require(vars.postId > 0 && vars.commentId > 0, "CommentData: wrong postId or commentId");

        Metadata storage comment = comments[vars.postId][vars.commentId];
        require(comment.timestamp > 0, "CommentData: wrong postId");

        gasConsumption = comment.gasConsumption;
        creator = comment.creator;
        owner = comment.owner;
        require(!gasCompensation[vars.postId][vars.commentId], "CommentData: wrong gas compensation");
        gasCompensation[vars.postId][vars.commentId] = true;

        emit SetGasCompensation(vars.executedId, vars.postId, vars.commentId);
    }

    function setGasConsumption(
        DataTypes.MinSimpleVars calldata vars
    ) external override onlyTrustedPlugin(PluginsList.COMMUNITY_WRITE_COMMENT, vars.pluginName, vars.version) returns(bool) {
        (uint256 _postId, uint256 _commentId, uint256 _gas) = abi.decode(vars.data,(uint256,uint256,uint256));

        Metadata storage comment = comments[_postId][_commentId];
        comment.gasConsumption = _gas;

        return true;
    }

    function readComment(
        DataTypes.MinSimpleVars calldata vars
    ) external view override onlyTrustedPlugin(PluginsList.COMMUNITY_READ_COMMENT, vars.pluginName, vars.version) returns(
        DataTypes.CommentInfo memory outData
    ) {
        (uint256 _postId, uint256 _commentId) = abi.decode(vars.data,(uint256,uint256));

        Metadata storage comment = comments[_postId][_commentId];
        if (comment.isView) {
            outData = convertMetadata(comment, _postId, _commentId);
        }
    }

    function getCommentCount(uint256 _postId) external view override returns(uint256) {
        return commentCount[_postId];
    }

    function getUpDownForComment(uint256 _postId, uint256 _commentId) external view override returns(bool _up, bool _down) {
        Metadata memory comment = comments[_postId][_commentId];
        _up = comment.up;
        _down = comment.down;
    }

    function convertMetadata(Metadata storage _inData, uint256 _postId, uint256 _commentId) private view returns(DataTypes.CommentInfo memory outData) {
        outData.creator = _inData.creator;
        outData.owner = _inData.owner;
        outData.ipfsHash = _inData.ipfsHash;
        outData.timestamp = _inData.timestamp;
        outData.gasConsumption = _inData.gasConsumption;
        outData.up = _inData.up;
        outData.down = _inData.down;
        outData.isEncrypted = _inData.isEncrypted;
        outData.isGasCompensation = gasCompensation[_postId][_commentId];
    }
}
