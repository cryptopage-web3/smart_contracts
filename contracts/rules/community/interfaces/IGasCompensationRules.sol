// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./IBaseRules.sol";


interface IGasCompensationRules {

    function validate(address _communityId, address _user) external view returns(address);

}
