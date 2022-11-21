// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

library Sets {

    // StringSet

    struct StringSet {
        string[] _values;
        mapping(string => uint256) _indexes;
    }

    function add(StringSet storage set, string memory value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function remove(StringSet storage set, string memory value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                string memory lastValue = set._values[lastIndex];

                set._values[toDeleteIndex] = lastValue;
                set._indexes[lastValue] = valueIndex;
            }

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function contains(StringSet storage set, string memory value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(StringSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(StringSet storage set, uint256 index) internal view returns (string memory) {
        return set._values[index];
    }

    function values(StringSet storage set) internal view returns (string[] memory) {
        string[] memory store = set._values;
        string[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        uint256[] _values;
        mapping(uint256 => uint256) _indexes;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                uint256 lastValue = set._values[lastIndex];

                set._values[toDeleteIndex] = lastValue;
                set._indexes[lastValue] = valueIndex;
            }

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return set._values[index];
    }

    function values(UintSet storage set) internal view returns (uint256[] memory) {
        uint256[] memory store = set._values;
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // Uint16Set

    struct Uint16Set {
        uint16[] _values;
        mapping(uint16 => uint256) _indexes;
    }

    function add(Uint16Set storage set, uint16 value) internal returns (bool) {
        if (!contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function remove(Uint16Set storage set, uint16 value) internal returns (bool) {
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                uint16 lastValue = set._values[lastIndex];

                set._values[toDeleteIndex] = lastValue;
                set._indexes[lastValue] = valueIndex;
            }

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function contains(Uint16Set storage set, uint16 value) internal view returns (bool) {
        return set._indexes[value] != 0;
    }

    function length(Uint16Set storage set) internal view returns (uint256) {
        return set._values.length;
    }

    function at(Uint16Set storage set, uint256 index) internal view returns (uint16) {
        return set._values[index];
    }

    function values(Uint16Set storage set) internal view returns (uint16[] memory) {
        uint16[] memory store = set._values;
        uint16[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}
