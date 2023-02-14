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

    function readPost(
        DataTypes.MinSimpleVars calldata vars
    ) external view returns(
        DataTypes.PostInfo memory outData
    );

    function getCommunityId(uint256 _postId) external view returns(address);

    function setVisibility(
        DataTypes.SimpleVars calldata vars
    ) external returns(bool);

    function setGasConsumption(
        DataTypes.MinSimpleVars calldata vars
    ) external returns(bool);

    function updatePostWhenNewComment(
        DataTypes.GeneralVars calldata vars
    ) external returns(bool);

    function setGasCompensation(
        DataTypes.SimpleVars calldata vars
    ) external returns(
        uint256 price,
        address creator
    );

    function isEncrypted(uint256 _postId) external view returns(bool);

    function isCreator(uint256 _postId, address _user) external view returns(bool);

}
