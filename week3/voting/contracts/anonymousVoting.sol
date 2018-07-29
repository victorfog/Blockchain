pragma solidity ^0.4.0;

contract anonymousVoting {


    struct structVoting {
        uint32 startDate;
        uint32 getSecretPhraseDate;
        uint32 endDate;
    }
    
    structVoting voting;
    mapping(bool => address[]) votes;
    mapping(address => bool) usersDb;

    constructor(uint32 _startDate, uint32 _getSecretPhaseDate, uint32 _endDate) public{
        voting = structVoting(_startDate, _getSecretPhaseDate, _endDate);
    }

    function vote(bool _vote) public {
        require(voting.startDate <= now);
        require(voting.endDate >= now);
        require(usersDb[msg.sender] != true);

        usersDb[msg.sender] = true;
        votes[_vote].push(msg.sender);


    }

    function stats() public view returns (uint, uint){
        address[] memory _arrayVotesNo = votes[false];
        address[] memory _arrayVotesYes = votes[true];
        uint no = _arrayVotesNo.length;
        uint yes = _arrayVotesYes.length;
        return (no, yes);
    }

}

