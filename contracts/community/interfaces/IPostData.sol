// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../libraries/DataTypes.sol";


interface IPostData {

    function version() external pure returns (string memory);

    function ipfsHashOf(uint256 _tokenId) external view returns (string memory);

    function writePost(
        DataTypes.GeneralVars calldata vars
    ) external returns(uint256);

    function burnPost(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function readPost(bytes32 _pluginName, uint256 _version, uint256 _postId) external view returns(
        bytes memory _data
    );

    function getCommunityId(uint256 _postId) external view returns(address);

    function setVisibility(
        DataTypes.SimpleVars calldata vars
    ) external returns(bool);

    function setGasConsumption(
        bytes32 _pluginName,
        uint256 _version,
        uint256 _postId,
        uint256 _gas
    ) external returns(bool);

    function updatePostWhenNewComment(
        DataTypes.GeneralVars calldata vars
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
