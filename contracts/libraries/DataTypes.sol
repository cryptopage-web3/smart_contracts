// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


library DataTypes {

    struct GasCompensationComment {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        uint256 postId;
        uint256 commentId;
    }

    struct GasCompensationBank {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        address user;
        uint256 gas;
    }
}
