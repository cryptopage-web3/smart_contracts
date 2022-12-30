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

    function burnComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(bool);

    function setVisibility(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        bytes memory _data
    ) external returns(bool);

    function setGasCompensation(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId
    ) external returns(
        uint256 gasConsumption,
        address creator
    );

    function setGasConsumption(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId,
        uint256 _gas
    ) external returns(bool);

    function readComment(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _commentId
    ) external view returns(bytes memory _data);

    function getCommentCount(uint256 _postId) external view returns(uint256);
}
