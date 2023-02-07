// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


interface IChangeVisibilityContentRules {

    function validate(address _communityId, address _moderator, uint256 _postId) external view returns(bool);
}
