// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IRegistry {

    function version() external pure returns (string memory);

    function bank() external view returns (address);

    function oracle() external view returns (address);

    function uniV3Pool() external view returns (address);

    function token() external view returns (address);

    function dao() external view returns (address);

    function treasury() external view returns (address);

    function executor() external view returns (address);

    function rule() external view returns (address);

    function communityData() external view returns (address);

    function postData() external view returns (address);

    function commentData() external view returns (address);

    function account() external view returns (address);

    function soulBound() external view returns (address);

    function nft() external view returns (address);

    function superAdmin() external view returns (address);

    function setBank(address _contract) external;

    function setToken(address _contract) external;

    function setOracle(address _contract) external;

    function setUniV3Pool(address _contract) external;

    function setExecutor(address _executor) external;

    function setCommunityData(address _contract) external;

    function setPostData(address _contract) external;

    function setCommentData(address _contract) external;

    function setAccount(address _contract) external;

    function setSoulBound(address _contract) external;

    function setRule(address _contract) external;

    function setNFT(address _contract) external;

    function setSuperAdmin(address _user) external;

    function setVotingContract(address _contract, bool _status) external;

    function setPlugin(
        bytes32 _pluginName,
        uint256 _version,
        address _pluginContract
    ) external;

    function changePluginStatus(
        bytes32 _pluginName,
        uint256 _version
    ) external;

    function getPlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (bool enable, address pluginContract);

    function getPluginContract(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (address pluginContract);

    function isEnablePlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (bool enable);

    function isVotingContract(
        address _contract
    ) external view returns (bool);
}
