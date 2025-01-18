
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for string;

    SillyStringUtils.Haiku public haiku;

    // Save a Haiku with three lines
    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    // Retrieve the Haiku as a struct
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Return a modified Haiku with "🤷" added to the end of line3
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory modifiedHaiku = haiku;
        modifiedHaiku.line3 = SillyStringUtils.shruggie(modifiedHaiku.line3);
        return modifiedHaiku;
    }
}
