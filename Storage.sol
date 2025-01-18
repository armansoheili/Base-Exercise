// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeStorage {
    // State variables
    uint16 private shares; // Optimized for storage (max value 65535, sufficient for shares < 5000)
    string public name;
    uint32 private salary; // Optimized for storage (max value 1,000,000 fits in 32 bits)
    uint256 public idNumber;

    // Custom error
    error TooManyShares(uint256 newTotalShares);

    // Constructor
    constructor() {
        shares = 1000;
        name = "Pat";
        salary = 50000;
        idNumber = 112358132134;
    }

    // View functions
    function viewSalary() public view returns (uint256) {
        return salary;
    }

    function viewShares() public view returns (uint256) {
        return shares;
    }

    // Grant shares
    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint256 newTotalShares = shares + _newShares;
        if (newTotalShares > 5000) {
            revert TooManyShares(newTotalShares);
        }
        shares += _newShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}
