// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

library Counter32bytes {
    struct Counter {
        uint8 _blockchainId;
        uint248 _value;
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return (uint256(counter._blockchainId) * 1e12) + uint256(counter._value);
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function set(
        Counter storage counter,
        uint8 blockchainId,
        uint248 value
        ) internal {
        counter._blockchainId = blockchainId;
        counter._value = value;
    }
}
