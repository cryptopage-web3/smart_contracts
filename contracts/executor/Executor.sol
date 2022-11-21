// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";

import "./interfaces/IExecutor.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/interfaces/IPlugin.sol";


contract Executor is OwnableUpgradeable, IExecutor {

    using AddressUpgradeable for address;

    IRegistry public registry;

    struct RunningData {
        address sender;
        bytes data;
        bytes32 id;
    }

    mapping(bytes32 => bool) public executedId;

    event Run(address origin, address sender, bytes32 id, bytes32 pluginName, uint256 version, bytes data);

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    ///constructor() initializer {}

    function initialize(address _registry) external initializer {
        __Ownable_init();
        registry = IRegistry(_registry);
    }

    function run(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes calldata _data) external {
        (bool enable, uint256 typeInterface, address pluginContract) = registry.getPlugin(_pluginName, _version);
        checkData(enable, pluginContract, _id);
        pluginContract.functionCall(
            abi.encodeWithSelector(
                IPlugin.execute.selector,
                _version,
                _msgSender(),
                _data
            )
        );

        emit Run(tx.origin, _msgSender(), _id, _pluginName, _version, _data);
    }

    function checkData(bool _enable, address _pluginContract, bytes32 _id) private {
        require(_enable, "Executor: wrong enable plugin");
        require(_pluginContract != address(0), "Executor: wrong plugin contract");
        require(!executedId[_id], "Executor: wrong id");
        executedId[_id] = true;
    }
}
