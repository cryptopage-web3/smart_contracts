// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../../libraries/DataTypes.sol";


interface ICommentData {

    function version() external pure returns (string memory);

    function ipfsHashOf(uint256 _postId, uint256 _commentId) external view returns (string memory);

    function writeComment(
        DataTypes.GeneralVars calldata vars
    ) external returns(uint256);

    function burnComment(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function setVisibility(
        DataTypes.SimpleVars calldata vars
    ) external returns(bool);

    function setGasCompensation(
        DataTypes.GasCompensationComment calldata vars
    ) external returns(
        uint256 gasConsumption,
        address creator,
        address owner
    );

    function setGasConsumption(
        DataTypes.MinSimpleVars calldata vars
    ) external returns(bool);

    function readComment(
        DataTypes.MinSimpleVars calldata vars
    ) external view returns(
        DataTypes.CommentInfo memory outData
    );

    function getCommentCount(uint256 _postId) external view returns(uint256);

    function getUpDownForComment(uint256 _postId, uint256 _commentId) external view returns(bool, bool);
}
