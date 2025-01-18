// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Manager {
    uint[] public employeeIds;

    function addReport(uint _idNumber) public {
        employeeIds.push(_idNumber);
    }

    function resetReports() public {
        delete employeeIds;
    }
}
