// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IRegistry {
    function version() external pure returns (string memory);

    function bank() external view returns (address);

    function token() external view returns (address);

    function dao() external view returns (address);

    function treasury() external view returns (address);

    function executor() external view returns (address);

    function rule() external view returns (address);

    function communityData() external view returns (address);

    function account() external view returns (address);

    function setExecutor(address _executor) external;

    function setCommunityData(address _contract) external;

    function setAccount(address _contract) external;

    function setPlugin(
        bytes32 _pluginName,
        uint256 _version,
        address _pluginContract,
        uint256 _typeInterface
    ) external;

    function changePluginStatus(
        bytes32 _pluginName,
        uint256 _version
    ) external;

    function getPlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (bool enable, uint256 typeInterface, address pluginContract);

    function getPluginContract(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (address pluginContract);

    function isEnablePlugin(
        bytes32 _pluginName,
        uint256 _version
    ) external view returns (bool enable);
}
