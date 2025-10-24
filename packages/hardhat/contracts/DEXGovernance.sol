// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title DEXGovernance
 * @notice Governance token for DEX parameter voting
 * @dev Simple governance for fee changes
 */
contract DEXGovernance is ERC20, Ownable {
    // Proposal structure
    struct Proposal {
        uint256 id;
        string description;
        uint256 newFeeNumerator; // New fee to set (e.g., 3 for 0.3%)
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
        mapping(address => bool) hasVoted;
    }

    // Proposals
    uint256 public proposalCount;
    mapping(uint256 => Proposal) public proposals;

    // Voting parameters
    uint256 public constant VOTING_PERIOD = 3 days;
    uint256 public constant PROPOSAL_THRESHOLD = 1000 * 10**18; // Need 1000 tokens to propose

    // Events
    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed proposer,
        string description,
        uint256 newFeeNumerator
    );
    event Voted(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 votes
    );
    event ProposalExecuted(uint256 indexed proposalId, bool passed);

    constructor() ERC20("DEX Governance Token", "DEXG") {
        // Mint initial supply to deployer
        _mint(msg.sender, 1_000_000 * 10**18); // 1M tokens
    }

    /**
     * @notice Create a new fee change proposal
     * @param description Proposal description
     * @param newFeeNumerator New fee numerator (e.g., 3 for 0.3%)
     */
    function propose(string memory description, uint256 newFeeNumerator)
        external
        returns (uint256)
    {
        require(
            balanceOf(msg.sender) >= PROPOSAL_THRESHOLD,
            "Insufficient tokens to propose"
        );
        require(newFeeNumerator <= 30, "Fee too high"); // Max 3%

        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.description = description;
        newProposal.newFeeNumerator = newFeeNumerator;
        newProposal.deadline = block.timestamp + VOTING_PERIOD;
        newProposal.executed = false;

        emit ProposalCreated(
            proposalCount,
            msg.sender,
            description,
            newFeeNumerator
        );

        return proposalCount;
    }

    /**
     * @notice Vote on a proposal
     * @param proposalId ID of proposal
     * @param support True for yes, false for no
     */
    function vote(uint256 proposalId, bool support) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp < proposal.deadline, "Voting ended");
        require(!proposal.hasVoted[msg.sender], "Already voted");

        uint256 votes = balanceOf(msg.sender);
        require(votes > 0, "No voting power");

        proposal.hasVoted[msg.sender] = true;

        if (support) {
            proposal.votesFor += votes;
        } else {
            proposal.votesAgainst += votes;
        }

        emit Voted(proposalId, msg.sender, support, votes);
    }

    /**
     * @notice Execute a proposal if it passed
     * @param proposalId ID of proposal to execute
     */
    function executeProposal(uint256 proposalId) external onlyOwner {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.deadline, "Voting not ended");
        require(!proposal.executed, "Already executed");

        bool passed = proposal.votesFor > proposal.votesAgainst;
        proposal.executed = true;

        emit ProposalExecuted(proposalId, passed);

        // Note: Actual fee change would be implemented in DEX contract
        // This is just the governance token
    }

    /**
     * @notice Get proposal details
     */
    function getProposal(uint256 proposalId)
        external
        view
        returns (
            uint256 id,
            string memory description,
            uint256 newFeeNumerator,
            uint256 votesFor,
            uint256 votesAgainst,
            uint256 deadline,
            bool executed
        )
    {
        Proposal storage proposal = proposals[proposalId];
        return (
            proposal.id,
            proposal.description,
            proposal.newFeeNumerator,
            proposal.votesFor,
            proposal.votesAgainst,
            proposal.deadline,
            proposal.executed
        );
    }

    /**
     * @notice Check if user has voted on proposal
     */
    function hasVoted(uint256 proposalId, address voter)
        external
        view
        returns (bool)
    {
        return proposals[proposalId].hasVoted[voter];
    }
}
