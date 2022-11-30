// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IPostData {

    function version() external pure returns (string memory);

    function ipfsHashOf(uint256 tokenId) external view returns (string memory);

}
