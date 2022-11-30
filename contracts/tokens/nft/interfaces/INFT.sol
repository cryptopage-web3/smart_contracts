// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol";

interface INFT is IERC721EnumerableUpgradeable {
    function version() external pure returns (string memory);

    function setBaseTokenURI(string memory baseTokenURI) external;

    function mint(
        address owner,
        uint256 tokenId
    ) external returns (uint256);

    function mint(
        address _creator,
//        address _owner,
        bool _repostable,
        uint256 _encodingType,
        string memory _ipfsHash,
        string memory _category,
        string[] memory tags
    ) external returns (uint256);

    function burn(uint256 tokenId) external;

    function tokenURI(uint256 tokenId) external view returns (string memory);

}
