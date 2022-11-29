// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../libraries/Sets.sol";
import "./interfaces/IPostData.sol";


contract PostData is OwnableUpgradeable, IPostData {

    struct Metadata {
        string ipfsHash;
        string category;
        address creator;
        address repostFromCommunity;
        uint64 upCount;
        uint64 downCount;
        uint256 price;
        uint256 commentCount;
        uint256 encodingType;
        uint256 timestamp;
        EnumerableSetUpgradeable.AddressSet upDownUsers;
        Sets.StringSet tags;
        bool isView;
    }

    //postId -> communityId
    mapping(uint256 => address) private communityIdByPostId;
    //postId -> Metadata
    mapping(uint256 => Metadata) private post;


    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    //constructor() initializer {}

    function initialize() external initializer {
        __Ownable_init();
    }

    function version() external pure override returns (string memory) {
        return "1";
    }
}
