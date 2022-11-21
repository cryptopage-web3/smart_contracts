// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IBaseRules {

    function validate(address communityId, bytes32 ruleName, address user) external view;

}
