// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";

import "./interfaces/IExecutor.sol";
import "../registry/interfaces/IRegistry.sol";
import "../plugins/interfaces/IExecutePlugin.sol";
import "../plugins/interfaces/IReadPlugin.sol";


contract Executor is OwnableUpgradeable, IExecutor {

    using AddressUpgradeable for address;

    address public validator;
    IRegistry public registry;

    struct RunningData {
        address sender;
        bytes validatorSig;
        bytes executionData;
    }

    mapping(bytes32 => bool) public executedId;

    event Run(address origin, address sender, bytes32 id, bytes32 pluginName, uint256 version, bytes data);
    event ValidatorSet(address sender, address indexed newValidator);

    /// @notice Constructs the contract.
    /// @dev The contract is automatically marked as initialized when deployed so that nobody can highjack the implementation contract.
    ///constructor() initializer {}

    function initialize(address _registry, address _validator) external initializer {
        __Ownable_init();
        registry = IRegistry(_registry);
        validator = _validator;
        emit ValidatorSet(_msgSender(), _validator);
    }

    function setValidator(address _validator) external onlyOwner {
        validator = _validator;
        emit ValidatorSet(_msgSender(), _validator);
    }

    function run(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes memory _data) external override {
        runPlugin(_id, _pluginName, _version, _data, _msgSender());
    }

    function gasLessRun(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes calldata _data) external override {
        RunningData memory runningData = abi.decode(_data,(RunningData));

        bytes32 digest = ECDSAUpgradeable.toEthSignedMessageHash(
            abi.encode(runningData.sender, runningData.executionData, _id)
        );
        checkValidatorSignature(digest, runningData.validatorSig);

        runPlugin(_id, _pluginName, _version, runningData.executionData, runningData.sender);
    }

    function runPlugin(bytes32 _id, bytes32 _pluginName, uint256 _version, bytes memory _data, address _sender) private {
        ( , address pluginContract) = registry.getPlugin(_pluginName, _version);
        require(!executedId[_id], "Executor: wrong id");
        executedId[_id] = true;

        bytes memory result = pluginContract.functionCall(
            abi.encodeWithSelector(
                IExecutePlugin.execute.selector,
                _id,
                _version,
                    _sender,
                _data
            )
        );
        (bool success) = abi.decode(result,(bool));
        require(success, "Executor: plugin didn't run");

        emit Run(tx.origin, _msgSender(), _id, _pluginName, _version, _data);
    }

    function checkValidatorSignature(
        bytes32 _digest,
        bytes memory _validatorSig
    ) private view {
        address signer = ECDSAUpgradeable.recover(_digest, _validatorSig);
        require(signer == validator, "Executor: not signed by validator");
    }
}
