// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "../registry/interfaces/IRegistry.sol";
import "../plugins/PluginsList.sol";
import "../libraries/Sets.sol";
import "./interfaces/IPostData.sol";
import "../tokens/nft/interfaces/INFT.sol";


contract PostData is Initializable, AccessControlUpgradeable, IPostData {

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

    IRegistry public registry;
    INFT public nft;

    //postId -> communityId
    mapping(uint256 => address) private communityIdByPostId;
    //postId -> Metadata
    mapping(uint256 => Metadata) private posts;

    modifier onlyWritePostPlugin(bytes32 _pluginName, uint256 _version) {
        require(_pluginName == PluginsList.COMMUNITY_WRITE_POST, "PostData: wrong plugin name");
        require(
            registry.getPluginContract(_pluginName, _version) == _msgSender(),
            "CommunityData: caller is not the plugin"
        );
        _;
    }

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    //constructor() initializer {}

    function initialize(address _registry) external initializer {
        registry = IRegistry(_registry);
        nft = INFT(registry.nft());
    }

    function version() external pure override returns (string memory) {
        return "1";
    }

    function ipfsHashOf(uint256 tokenId) external override view returns (string memory) {
        return posts[tokenId].ipfsHash;
    }

    function createPost(bytes memory _data) external returns(bool) {
        uint256 tokenId = 1;
        Metadata storage post = posts[tokenId];

        return true;
    }
}
