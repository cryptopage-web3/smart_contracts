// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IBaseRules {

    function validate(address _communityId, address _user) external view returns(bool);

}
