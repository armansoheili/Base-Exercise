// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HaikuNFT is ERC721 {
    using Counters for Counters.Counter;

    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus;
    mapping(address => uint256[]) public sharedHaikus;
    Counters.Counter public counter; // Public for easier debugging

    mapping(string => bool) private usedLines; // Tracks used lines for uniqueness

    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    constructor() ERC721("HaikuNFT", "HAIKU") {
        counter.increment(); // Start at 1 for 1-based IDs
    }

    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external {
        // Ensure lines are unique
        if (usedLines[_line1] || usedLines[_line2] || usedLines[_line3]) {
            revert HaikuNotUnique();
        }

        uint256 newHaikuId = counter.current(); // Get current ID
        _safeMint(msg.sender, newHaikuId); // Safe mint for compliance

        // Push new haiku to the array
        haikus.push(
            Haiku({
                author: msg.sender,
                line1: _line1,
                line2: _line2,
                line3: _line3
            })
        );

        // Mark lines as used
        usedLines[_line1] = true;
        usedLines[_line2] = true;
        usedLines[_line3] = true;

        counter.increment(); // Increment counter
    }

    function shareHaiku(uint256 _haikuId, address _to) public {
        if (ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }

        // Share the haiku with the recipient
        sharedHaikus[_to].push(_haikuId);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory sharedIds = sharedHaikus[msg.sender];

        if (sharedIds.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory mySharedHaikus = new Haiku[](sharedIds.length);

        for (uint256 i = 0; i < sharedIds.length; i++) {
            // Ensure valid indexing
            uint256 haikuId = sharedIds[i];
            require(haikuId > 0 && haikuId <= haikus.length, "Invalid haiku ID");

            mySharedHaikus[i] = haikus[haikuId - 1];
        }

        return mySharedHaikus;
    }
}
