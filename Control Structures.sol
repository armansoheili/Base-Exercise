// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ControlStructures {
    // Define custom errors for efficient error handling
    error AfterHours(uint256 time);
    error AtLunch();

    /**
     * @dev FizzBuzz function to check a number and return a string.
     * @param _number The input number to evaluate.
     * @return response The appropriate FizzBuzz response.
     */
    function fizzBuzz(uint256 _number) public pure returns (string memory response) {
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

    /**
     * @dev Function to determine activity based on the time of day.
     * @param _time The time in HHMM format (e.g., 1300 for 1:00 PM).
     * @return result A string message indicating the appropriate time-based response.
     */
    function doNotDisturb(uint256 _time) public pure returns (string memory result) {
        // Validate time input using assert
        assert(_time < 2400); // Ensure the time is a valid 24-hour format value

        // Handle time ranges with custom errors and messages
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time); // Custom error for after hours
        } else if (_time >= 1200 && _time <= 1259) {
            revert AtLunch(); // Custom error for lunch hour
        } else if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // No fallback return value as all cases are covered
        revert("Unhandled time range!");
    }
}
