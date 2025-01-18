// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title GarageManager
 * @dev Contract to manage a garage of cars for each user.
 */
contract GarageManager {
    // Mapping to store a user's garage of cars
    mapping(address => Car[]) private garages;

    // Struct to represent a car
    struct Car {
        string make;         // Car brand
        string model;        // Car model
        string color;        // Car color
        uint numberOfDoors;  // Number of doors
    }

    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    /**
     * @dev Add a new car to the caller's garage.
     * @param _make The car brand.
     * @param _model The car model.
     * @param _color The car color.
     * @param _numberOfDoors The number of doors on the car.
     */
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        // Add a new car struct to the caller's garage
        garages[msg.sender].push(Car(_make, _model, _color, _numberOfDoors));
    }

    /**
     * @dev Retrieve all cars in the caller's garage.
     * @return An array of Car structs owned by the caller.
     */
    function getMyCars() external view returns (Car[] memory) {
        return garages[msg.sender];
    }

    /**
     * @dev Retrieve all cars owned by a specific user.
     * @param _user The address of the user whose garage is being queried.
     * @return An array of Car structs owned by the specified user.
     */
    function getUserCars(address _user) external view returns (Car[] memory) {
        return garages[_user];
    }

    /**
     * @dev Update details of a specific car in the caller's garage.
     * @param _index The index of the car in the garage array.
     * @param _make The updated car brand.
     * @param _model The updated car model.
     * @param _color The updated car color.
     * @param _numberOfDoors The updated number of doors.
     */
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        // Ensure the car index is valid
        if (_index >= garages[msg.sender].length) {
            revert BadCarIndex({index: _index});
        }

        // Update the car details at the specified index
        garages[msg.sender][_index] = Car(_make, _model, _color, _numberOfDoors);
    }

    /**
     * @dev Remove all cars from the caller's garage.
     */
    function resetMyGarage() external {
        delete garages[msg.sender];
    }
}
