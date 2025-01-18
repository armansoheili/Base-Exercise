// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Errors
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh();
    error AlreadyVoted();
    error VotingClosed();

    // Data Structures
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    struct SerializedIssue {
        address[] voters;
        string issueDesc;
        uint256 quorum;
        uint256 totalVotes;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    // State Variables
    Issue[] internal issues;
    mapping(address => bool) public tokensClaimed;

    uint256 public constant maxSupply = 1000000; // Total supply: 1,000,000 tokens
    uint256 public constant claimAmount = 100; // Claim amount: 100 tokens

    // Constructor
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push(); // Placeholder issue at index 0
    }

    /**
     * @dev Claim tokens, one-time claim per address.
     */
    function claim() public {
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed(); // Ensure total supply limit
        }
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed(); // Check if tokens already claimed
        }

        _mint(msg.sender, claimAmount);
        tokensClaimed[msg.sender] = true;
    }

    /**
     * @dev Create a new issue for voting.
     * @param _issueDesc The description of the issue.
     * @param _quorum The quorum required for the issue.
     * @return The ID of the created issue.
     */
    function createIssue(string calldata _issueDesc, uint256 _quorum)
        external
        returns (uint256)
    {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld(); // Only token holders can create issues
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(); // Quorum must not exceed total supply
        }

        Issue storage _issue = issues.push();
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;

        return issues.length - 1; // Return the issue ID
    }

    /**
     * @dev Retrieve issue details by ID.
     * @param _issueId The ID of the issue.
     * @return The serialized issue details.
     */
    function getIssue(uint256 _issueId)
        external
        view
        returns (SerializedIssue memory)
    {
        Issue storage _issue = issues[_issueId];
        return
            SerializedIssue({
                voters: _issue.voters.values(),
                issueDesc: _issue.issueDesc,
                quorum: _issue.quorum,
                totalVotes: _issue.totalVotes,
                votesFor: _issue.votesFor,
                votesAgainst: _issue.votesAgainst,
                votesAbstain: _issue.votesAbstain,
                passed: _issue.passed,
                closed: _issue.closed
            });
    }

    /**
     * @dev Vote on an issue.
     * @param _issueId The ID of the issue.
     * @param _vote The type of vote (FOR, AGAINST, ABSTAIN).
     */
    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];

        if (_issue.closed) {
            revert VotingClosed(); // Ensure issue is still open
        }
        if (_issue.voters.contains(msg.sender)) {
            revert AlreadyVoted(); // Prevent double voting
        }

        uint256 nTokens = balanceOf(msg.sender);
        if (nTokens == 0) {
            revert NoTokensHeld(); // Only token holders can vote
        }

        // Record the vote
        if (_vote == Vote.AGAINST) {
            _issue.votesAgainst += nTokens;
        } else if (_vote == Vote.FOR) {
            _issue.votesFor += nTokens;
        } else {
            _issue.votesAbstain += nTokens;
        }

        _issue.voters.add(msg.sender);
        _issue.totalVotes += nTokens;

        // Check if quorum is met
        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true; // Close the issue
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true; // Pass the issue if FOR votes exceed AGAINST
            }
        }
    }
}
