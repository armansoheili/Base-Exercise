// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AddressBook {
    address public owner;

    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    mapping(uint => Contact) private contacts;
    uint[] private contactIds;

    error ContactNotFound(uint id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function addContact(
        uint _id,
        string memory _firstName,
        string memory _lastName,
        uint[] memory _phoneNumbers
    ) public onlyOwner {
        contacts[_id] = Contact(_id, _firstName, _lastName, _phoneNumbers);
        contactIds.push(_id);
    }

    function deleteContact(uint _id) public onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];

        for (uint i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }

    function getContact(uint _id)
        public
        view
        returns (
            uint id,
            string memory firstName,
            string memory lastName,
            uint[] memory phoneNumbers
        )
    {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        Contact memory contact = contacts[_id];
        return (contact.id, contact.firstName, contact.lastName, contact.phoneNumbers);
    }

    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);

        for (uint i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }

        return allContacts;
    }
}
