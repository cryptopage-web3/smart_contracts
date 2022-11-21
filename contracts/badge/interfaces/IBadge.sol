// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface IBadge is IERC1155Upgradeable {
    function version() external pure returns (string memory);

    function mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external;

    function burn(
        address account,
        uint256 id,
        uint256 value
    ) external;

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external;

    function burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory values
    ) external;
}
