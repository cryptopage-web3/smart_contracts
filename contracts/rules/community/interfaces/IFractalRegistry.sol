// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IFractalRegistry {

    /// @param addr is Eth address
    /// @return FractalId as bytes32
    function getFractalId(address addr) external view returns (bytes32);

    /// @notice Checks if a user by FractalId exists in a specific list.
    /// @param userId is FractalId in bytes32.
    /// @param listId is the list id.
    /// @return bool if the user is the specified list.
    function isUserInList(bytes32 userId, string memory listId) external view returns (bool);

}
