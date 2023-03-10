// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

interface IBaseRulesWithPostId {

    function validate(address _communityId, address _user, uint256 _postId) external view returns(bool);

}
