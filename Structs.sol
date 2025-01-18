// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GarageManager {
    // Car struct
    struct Car {
        string make;
        string model;
        string color;
        uint8 numberOfDoors;
    }

    // Mapping of addresses to their cars
    mapping(address => Car[]) public garage;

    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    // Add a car to the sender's garage
    function addCar(
        string memory make,
        string memory model,
        string memory color,
        uint8 numberOfDoors
    ) public {
        Car memory newCar = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });
        garage[msg.sender].push(newCar);
    }

    // Get all cars owned by the caller
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Get all cars owned by a specific user
    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    // Update a car at a specific index in the sender's garage
    function updateCar(
        uint256 index,
        string memory make,
        string memory model,
        string memory color,
        uint8 numberOfDoors
    ) public {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }

        garage[msg.sender][index] = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });
    }

    // Reset the sender's garage
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
