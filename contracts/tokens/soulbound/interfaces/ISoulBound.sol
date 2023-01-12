// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

import "../../../libraries/DataTypes.sol";


interface ISoulBound is IERC1155Upgradeable {

    function version() external pure returns (string memory);

    function mint(
        DataTypes.SoulBoundMintBurn calldata vars
    ) external;

    function burn(
        DataTypes.SoulBoundMintBurn calldata vars
    ) external;

    function mintBatch(
        DataTypes.SoulBoundBatchMintBurn calldata vars
    ) external;

    function burnBatch(
        DataTypes.SoulBoundBatchMintBurn calldata vars
    ) external;
}
