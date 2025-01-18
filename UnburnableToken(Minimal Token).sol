// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UnburnableToken {
    // Tracks balances of users
    mapping(address => uint) public balances;
    // Total supply of the token
    uint public totalSupply = 100_000_000;
    // Total tokens claimed by users
    uint public totalClaimed;
    // Tracks whether a user has claimed their tokens
    mapping(address => bool) private hasClaimed;

    // Custom errors for more efficient reverts
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    // Constructor: initializes the total supply
    constructor() {}

    // Function to allow users to claim tokens
    function claim() public {
        // Check if the user has already claimed
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }
        // Check if there are enough tokens left to claim
        if (totalClaimed + 1000 > totalSupply) {
            revert AllTokensClaimed();
        }

        // Mark the user as having claimed and update state
        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 1000; // Add 1000 tokens to the user's balance
        totalClaimed += 1000;        // Update the total claimed amount
    }

    // Safe transfer function to securely transfer tokens
    function safeTransfer(address _to, uint _amount) public {
        // Prevent transfers to the zero address
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        // Prevent transfers to addresses with no ETH balance
        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        // Ensure the sender has enough balance for the transfer
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
