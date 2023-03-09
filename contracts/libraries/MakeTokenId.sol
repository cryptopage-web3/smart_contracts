// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;


library MakeTokenId {

    uint256 constant ADDITIONAL_ID = 1_000_000;

    function getRateId(uint256 _tokenId) internal view returns(uint256) {
        return _tokenId % (ADDITIONAL_ID * getChainId());
    }

    function getSoulBoundTokenId(address _value, uint256 _rateId) internal view returns(uint256) {
        return uint256(uint160(_value)) * ADDITIONAL_ID * getChainId() + _rateId;
    }

    function getChainId() private view returns (uint256 chainId) {
        assembly {
            chainId := chainid()
        }
    }
}
