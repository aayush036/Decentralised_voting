// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Voting {
    event Voted(address indexed voter, uint indexed candidateId);
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    struct Candidate {
        string name;
        uint votes;
    }
    mapping(uint => Candidate) public candidates;
    uint public candidateCount;

    struct Voter {
        bool authorized;
        bool voted;
        uint candidateId;
    }
    mapping(address => Voter) public voters;

    function addCandidate(string memory name) public onlyOwner {
        candidateCount++;
        candidates[candidateCount] = Candidate(name, 0);
    }

    function authorizeVote(address voterAddress) public onlyOwner {
        voters[voterAddress].authorized = true;
    }

    function vote(uint candidateID) public {
        require(
            voters[msg.sender].authorized == true,
            "you are not authorised to vote"
        );
        require(voters[msg.sender].voted == false, "youve already voted");
        require(
            candidateID > 0 && candidateID <= candidateCount,
            "Invalid Candidate ID"
        );
        candidates[candidateID].votes++;
        voters[msg.sender].voted = true;
        voters[msg.sender].candidateId = candidateID;
        emit Voted(msg.sender, candidateID);
    }
}
