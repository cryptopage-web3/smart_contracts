// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


library DataTypes {

    struct  GeneralVars {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        address user;
        bytes data;
    }

    struct UserRateCount {
        uint256 commentCount;
        uint256 postCount;
        uint256 upCount;
        uint256 downCount;
    }

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
