// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IPostData {

    function version() external pure returns (string memory);

    function ipfsHashOf(uint256 _tokenId) external view returns (string memory);

    function writePost(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(uint256);

    function readPost(uint256 _postId) external view returns(
        string memory ipfsHash,
        string memory category,
        string[] memory tags,
        address creator,
        address repostFromCommunity,
        uint64 upCount,
        uint64 downCount,
        uint256 price,
        uint256 encodingType,
        uint256 timestamp,
        address[] memory upDownUsers,
        bool isView
    );

    function setVisibility(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        bytes memory _data
    ) external returns(bool);

    function setPrice(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _price
    ) external returns(bool);

    function updatePostWhenNewComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(bool);
}
