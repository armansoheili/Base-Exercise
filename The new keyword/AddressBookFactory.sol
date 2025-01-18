// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./AddressBook.sol";

contract AddressBookFactory {
    event AddressBookDeployed(address indexed owner, address indexed addressBook);

    function deploy() public returns (address) {
        // Deploy the AddressBook contract
        AddressBook newAddressBook = new AddressBook();

        // Transfer ownership of the AddressBook to the deployer
        newAddressBook.transferOwnership(msg.sender);

        // Emit an event with the owner and deployed contract address
        emit AddressBookDeployed(msg.sender, address(newAddressBook));

        return address(newAddressBook);
    }
}
