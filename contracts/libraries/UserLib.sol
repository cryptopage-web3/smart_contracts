// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "../registry/interfaces/IRegistry.sol";
import "../account/interfaces/IAccount.sol";
import "../community/interfaces/ICommentData.sol";
import "./DataTypes.sol";

library UserLib {

    function getUserRate(
        IRegistry registry,
        address _user,
        address _communityId
    ) internal view returns(DataTypes.UserRateCount memory _counts) {
        (uint256[] memory withCommentPostIds, uint256[] memory createdPostIds) =
        IAccount(registry.account()).getPostIdsByUserAndCommunity(_communityId, _user);

        _counts.postCount += createdPostIds.length;
        for(uint256 j=0; j < withCommentPostIds.length; j++) {
            uint256 postId = withCommentPostIds[j];
            uint256[] memory commentIds = IAccount(registry.account()).getCommentIdsByUserAndPost(_communityId, _user, postId);
            _counts.commentCount += commentIds.length;
            for(uint256 k=0; k < commentIds.length; k++) {
                uint256 commentId = commentIds[k];
                (bool isUp, bool isDown) = ICommentData(registry.commentData()).getUpDownForComment(
                    postId,
                    commentId
                );
                if (isUp) {
                    _counts.upCount++;
                }
                if (isDown) {
                    _counts.downCount++;
                }
            }
        }
    }
}
