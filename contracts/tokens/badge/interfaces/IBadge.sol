// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

import "../../../libraries/DataTypes.sol";


interface IBadge is IERC1155Upgradeable {

    function version() external pure returns (string memory);

    function mint(
        DataTypes.BadgeMintBurn calldata vars
    ) external;

    function burn(
        DataTypes.BadgeMintBurn calldata vars
    ) external;

    function mintBatch(
        DataTypes.BadgeBatchMintBurn calldata vars
    ) external;

    function burnBatch(
        DataTypes.BadgeBatchMintBurn calldata vars
    ) external;
}
