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

    function burnPost(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(bool);

    function readPost(bytes32 _pluginName, uint256 _version, uint256 _postId) external view returns(
        bytes memory _data
    );

    function getCommunityId(uint256 _postId) external view returns(address);

    function setVisibility(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        bytes memory _data
    ) external returns(bool);

    function setGasConsumption(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _gas
    ) external returns(bool);

    function updatePostWhenNewComment(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        address _sender,
        bytes memory _data
    ) external returns(bool);

    function setGasCompensation(
        bytes32 _executedId,
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId
    ) external returns(
        uint256 price,
        address creator
    );
}
