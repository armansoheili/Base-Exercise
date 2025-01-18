// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FavoriteRecords {
    // State variables
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavorites;
    string[] private approvedRecordList;

    error NotApproved(string albumName);

    // Constructor to initialize approved records
    constructor() {
        string[10] memory records = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever",
            "Get Approved Records"
        ];

        for (uint i = 0; i < records.length; i++) {
            approvedRecords[records[i]] = true;
            approvedRecordList.push(records[i]);
        }
    }

    // Get the list of approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordList;
    }

    // Add a record to the user's favorites
    function addRecord(string calldata albumName) public {
        if (!approvedRecords[albumName]) {
            revert NotApproved(albumName);
        }
        userFavorites[msg.sender][albumName] = true;
    }

    // Get the list of user's favorite records
    function getUserFavorites(address user) public view returns (string[] memory) {
        uint count;
        for (uint i = 0; i < approvedRecordList.length; i++) {
            if (userFavorites[user][approvedRecordList[i]]) {
                count++;
            }
        }

        string[] memory favorites = new string[](count);
        uint index;
        for (uint i = 0; i < approvedRecordList.length; i++) {
            if (userFavorites[user][approvedRecordList[i]]) {
                favorites[index] = approvedRecordList[i];
                index++;
            }
        }
        return favorites;
    }

    // Reset the user's favorite records
    function resetUserFavorites() public {
        for (uint i = 0; i < approvedRecordList.length; i++) {
            userFavorites[msg.sender][approvedRecordList[i]] = false;
        }
    }
}
