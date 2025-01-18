// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArraysExercise {
    uint[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    address[] public senders;
    uint[] public timestamps;

    // Return the entire numbers array
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    // Reset the numbers array to its initial values
    function resetNumbers() public {
        delete numbers; // Clears the array
        for (uint i = 1; i <= 10; i++) {
            numbers.push(i);
        }
    }

    // Append a given array to the numbers array
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Save the sender and timestamp
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Return timestamps and corresponding senders after Y2K
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint count;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                count++;
            }
        }

        uint[] memory filteredTimestamps = new uint[](count);
        address[] memory filteredSenders = new address[](count);
        uint index;

        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                filteredTimestamps[index] = timestamps[i];
                filteredSenders[index] = senders[i];
                index++;
            }
        }

        return (filteredTimestamps, filteredSenders);
    }

    // Reset the senders array
    function resetSenders() public {
        delete senders;
    }

    // Reset the timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}
