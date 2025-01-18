// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AddressBook.sol";

contract AddressBookFactory {
    event AddressBookDeployed(address indexed owner, address indexed addressBook);

    function deploy() public returns (address) {
        // Deploy the AddressBook contract with msg.sender as the initial owner
        AddressBook newAddressBook = new AddressBook(msg.sender);

        // Emit an event to log the deployment
        emit AddressBookDeployed(msg.sender, address(newAddressBook));

        // Return the address of the deployed AddressBook contract
        return address(newAddressBook);
    }
}
