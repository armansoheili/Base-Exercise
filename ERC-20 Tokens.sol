// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    uint256 public constant maxSupply = 1_000_000 * 10 ** 18;
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] public issues;

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    mapping(address => bool) private claimed;

    constructor() ERC20("WeightedVotingToken", "WVT") {
        _mint(address(this), maxSupply);
        // Burn zeroeth issue as placeholder
        issues.push();
    }

    function claim() public {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalSupply() >= maxSupply) {
            revert AllTokensClaimed();
        }

        claimed[msg.sender] = true;
        _transfer(address(this), msg.sender, 100 * 10 ** 18);
    }

    function createIssue(string calldata _description, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _description;
        newIssue.quorum = _quorum;

        return issues.length - 1;
    }

    function getIssue(uint256 _id) external view returns (
        string memory issueDesc,
        uint256 votesFor,
        uint256 votesAgainst,
        uint256 votesAbstain,
        uint256 totalVotes,
        uint256 quorum,
        bool passed,
        bool closed
    ) {
        Issue storage issue = issues[_id];
        return (
            issue.issueDesc,
            issue.votesFor,
            issue.votesAgainst,
            issue.votesAbstain,
            issue.totalVotes,
            issue.quorum,
            issue.passed,
            issue.closed
        );
    }

    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage issue = issues[_issueId];

        if (issue.closed) {
            revert VotingClosed();
        }

        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }

        uint256 voterTokens = balanceOf(msg.sender);
        if (voterTokens == 0) {
            revert NoTokensHeld();
        }

        issue.voters.add(msg.sender);
        issue.totalVotes += voterTokens;

        if (_vote == Vote.FOR) {
            issue.votesFor += voterTokens;
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += voterTokens;
        } else if (_vote == Vote.ABSTAIN) {
            issue.votesAbstain += voterTokens;
        }

        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            if (issue.votesFor > issue.votesAgainst) {
                issue.passed = true;
            }
        }
    }
}
