
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./AddressBook.sol";

contract AddressBookFactory {
    event AddressBookDeployed(address indexed owner, address indexed addressBook);

    function deploy() public returns (address) {
        AddressBook newAddressBook = new AddressBook();
        newAddressBook.transferOwnership(msg.sender);
        emit AddressBookDeployed(msg.sender, address(newAddressBook));
        return address(newAddressBook);
    }
}
