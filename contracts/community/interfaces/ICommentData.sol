// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface ICommentData {

    function version() external pure returns (string memory);

    function ipfsHashOf(uint256 _postId, uint256 _commentId) external view returns (string memory);

    function writeComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(uint256);

    function setPrice(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId,
        uint256 _price
    ) external returns(bool);

    function readComment(uint256 _postId, uint256 _commentId) external view returns(
        string memory ipfsHash,
        address creator,
        address owner,
        uint256 price,
        uint256 timestamp,
        bool up,
        bool down,
        bool isView
    );
}
