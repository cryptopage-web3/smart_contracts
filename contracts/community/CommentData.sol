// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "./interfaces/IPostData.sol";


contract CommentData is OwnableUpgradeable, ICommentData {

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

    //postId -> commentId -> Metadata
    mapping(uint256 => mapping(uint256 => Metadata)) private comments;

    //postId -> user -> commentIds
    mapping(uint256 => mapping(address => EnumerableSetUpgradeable.UintSet)) private userToCommentIds;


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

}
