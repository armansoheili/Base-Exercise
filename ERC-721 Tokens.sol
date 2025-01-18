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
    Counters.Counter private _haikuCounter;
    mapping(bytes32 => bool) private _usedHaikuLines;

    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    constructor() ERC721("HaikuNFT", "HAIKU") {
        _haikuCounter.increment(); // Start the counter at 1
    }

    function mintHaiku(string calldata line1, string calldata line2, string calldata line3) external {
        bytes32 line1Hash = keccak256(abi.encodePacked(line1));
        bytes32 line2Hash = keccak256(abi.encodePacked(line2));
        bytes32 line3Hash = keccak256(abi.encodePacked(line3));

        if (_usedHaikuLines[line1Hash] || _usedHaikuLines[line2Hash] || _usedHaikuLines[line3Hash]) {
            revert HaikuNotUnique();
        }

        _usedHaikuLines[line1Hash] = true;
        _usedHaikuLines[line2Hash] = true;
        _usedHaikuLines[line3Hash] = true;

        uint256 newHaikuId = _haikuCounter.current();
        _haikuCounter.increment();

        haikus.push(Haiku(msg.sender, line1, line2, line3));
        _mint(msg.sender, newHaikuId);
    }

    function shareHaiku(address _to, uint256 _haikuId) public {
        if (ownerOf(_haikuId) != msg.sender) {
            revert NotYourHaiku(_haikuId);
        }

        sharedHaikus[_to].push(_haikuId);
    }

    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory sharedIds = sharedHaikus[msg.sender];
        uint256 count = sharedIds.length;

        if (count == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = haikus[sharedIds[i] - 1]; // IDs are 1-based, adjust for array indexing
        }

        return result;
    }
}
