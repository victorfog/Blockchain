pragma solidity ^0.4.0;

contract anonymousVoting {

    struct structVoting {
        uint32 startDate;
        uint32 getSecretPhraseDate;
        uint32 endDate;
    }

    structVoting voting;

    constructor(uint32 _startDate, uint32 _getSecretPhaseDate, uint32 _endDate) public{
        voting = structVoting(_startDate, _getSecretPhaseDate, _endDate);
    }


}

