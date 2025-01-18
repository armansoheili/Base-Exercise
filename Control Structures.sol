// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ControlStructures {
    // Function: fizzBuzz
    function fizzBuzz(uint _number) public pure returns (string memory) {
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    // Custom error for after hours
    error AfterHours(uint time);

    // Function: doNotDisturb
    function doNotDisturb(uint _time) public pure returns (string memory) {
        require(_time < 2400, "Invalid time: must be less than 2400");

        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        } else if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        } else if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        return "Invalid time!"; // Fallback, though this should never be reached
    }
}
