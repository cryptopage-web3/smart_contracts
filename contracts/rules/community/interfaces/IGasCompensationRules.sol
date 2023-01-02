// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "./IBaseRules.sol";


interface IGasCompensationRules {

    function validate(
        address _communityId,
        address _author,
        address _owner
    ) external view returns(address[] memory);

}
