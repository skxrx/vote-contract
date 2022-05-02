//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract Vote {
    //Basic declarations
    address public owner;
    uint256 public constant VOTING_DURATION = 3 days;

    //Add strcuts of voting candidate and voting process
    struct Candidate {
        address candidateAddress;
        uint256 voteCount;
    }

    struct Voting {
        bool isVotingEnded;
        Candidate[] candidates;
        uint256 poolToWin;
        uint256 commission;
        mapping(address => bool) votersVoted;
        address winnerAddress;
        uint256 votingUpTime;
    }

    uint256 votingId;
    mapping(uint256 => Voting) public votings;

    modifier isOwner() {
        require(msg.sender == owner, "You are not an owner");
        _;
    }

    event NewVotingAdded(uint256 votingId);
    event VotingFinished(uint256 votingId, address winner);

    constructor() {
        owner = msg.sender;
    }

    function addVoting(address[] memory _candidateAddress) public isOwner {
        //Add new voting to blockchain
        Voting storage voting = votings[votingId];
        for (uint256 i = 0; i < _candidateAddress.length; ++i) {
            voting.candidates.push(
                Candidate({
                    candidateAddress: _candidateAddress[i],
                    voteCount: 0
                })
            );
        }
        voting.votingUpTime = block.timestamp + VOTING_DURATION;
        emit NewVotingAdded(votingId);
        votingId++;
    }

    function finishVoting(uint256 _votingId) public returns (address) {
        Voting storage voting = votings[_votingId];
        require(!voting.isVotingEnded, "Voting has been ended");
        require(block.timestamp >= voting.votingUpTime, "Voting is not over");
        uint256 len = voting.candidates.length;
        uint256 winVoteCount = 0;
        uint256 winingCandidateId;
        for (uint256 p = 0; p < len; ++p) {
            if (voting.candidates[p].voteCount > winVoteCount) {
                winVoteCount = voting.candidates[p].voteCount;
                winingCandidateId = p;
            }
        }
        voting.isVotingEnded = true;
        address winnerAddr = voting
            .candidates[winingCandidateId]
            .candidateAddress;
        payable(winnerAddr).transfer(voting.poolToWin);
        voting.poolToWin = 0;
        emit VotingFinished(_votingId, winnerAddr);
        voting.winnerAddress = winnerAddr;
        return winnerAddr;
    }

    function vote(uint256 _votingId, uint256 voteFor) external payable {
        require(msg.value >= .01 ether, "You must send more than 0.01 ETH");
        Voting storage voting = votings[_votingId];
        require(!voting.isVotingEnded, "Voting has been ended");
        require(!voting.votersVoted[msg.sender], "You are already voted");
        voting.poolToWin += (msg.value * 9) / 10;
        voting.commission += (msg.value) / 10;
        voting.votersVoted[msg.sender] = true;
        voting.candidates[voteFor].voteCount++;
    }

    function withdrawCommission(uint256 _votingId) public isOwner {
        Voting storage voting = votings[_votingId];
        payable(owner).transfer(voting.commission);
        voting.commission = 0;
    }

    function viewVoting(uint256 _votingId)
        public
        view
        returns (Candidate[] memory, address)
    {
        return (
            votings[_votingId].candidates,
            votings[_votingId].winnerAddress
        );
    }
}
