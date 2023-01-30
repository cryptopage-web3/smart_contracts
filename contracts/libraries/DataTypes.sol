// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";


library DataTypes {

    struct PostMetadata {
        address creator;
        address repostFromCommunity;
        uint256 upCount;
        uint256 downCount;
        uint256 encodingType;
        uint256 timestamp;
        bool isEncrypted;
        bool isGasCompensation;
        string ipfsHash;
        string category;
        string[] tags;
    }

    struct CommentMetadata {
        address creator;
        address owner;
        string ipfsHash;
        uint256 timestamp;
        bool up;
        bool down;
        bool isEncrypted;
        bool isGasCompensation;
    }

    enum UserRatesType {
        RESERVE, FOR_POST, FOR_COMMENT, FOR_UP, FOR_DOWN,
        FOR_DEAL_GUARANTOR, FOR_DEAL_SELLER, FOR_DEAL_BUYER
    }

    struct MinSimpleVars {
        bytes32 pluginName;
        uint256 version;
        bytes data;
    }

    struct SimpleVars {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        bytes data;
    }

    struct GeneralVars {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        address user;
        bytes data;
    }

    struct SoulBoundMintBurn {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        address user;
        uint256 id;
        uint256 amount;
    }

    struct SoulBoundBatchMintBurn {
        bytes32 executedId;
        bytes32 pluginName;
        uint256 version;
        address user;
        uint256[] ids;
        uint256[] amounts;
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
