// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";

interface INFT is IERC721EnumerableUpgradeable {
    function version() external pure returns (string memory);

    function setBaseTokenURI(string memory baseTokenURI) external;

    function mint(address _owner) external returns (uint256);

    function burn(uint256 tokenId) external;

    function setReceiveApproved(address to, uint256 tokenId) external;

    function getReceiveApproved(uint256 tokenId) external view returns (address);

    function tokensOfOwner(address user) external view returns (uint256[] memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);

}
