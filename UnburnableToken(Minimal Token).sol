// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract UnburnableToken {
    mapping(address => uint) public balances;
    uint public totalSupply = 100000000;
    uint public totalClaimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    mapping(address => bool) private hasClaimed;

    constructor() {}

    function claim() public {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_to == address(0) || balances[_to] == 0) {
            revert UnsafeTransfer(_to);
        }
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
