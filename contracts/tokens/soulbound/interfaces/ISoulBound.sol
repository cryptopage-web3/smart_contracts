// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

import "../../../libraries/DataTypes.sol";


interface ISoulBound is IERC1155Upgradeable {

    function version() external pure returns (string memory);

    function mint(
        DataTypes.SoulBoundMint calldata vars
    ) external;

    function mintBatch(
        DataTypes.SoulBoundBatchMint calldata vars
    ) external;

    function getTokenIdByCommunityAndRate(
        address communityId,
        uint256 rateId
    ) external view returns (uint256);
}
