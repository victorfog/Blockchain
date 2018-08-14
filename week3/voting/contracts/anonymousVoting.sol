pragma solidity ^0.4.0;

contract anonymousVoting {


    struct structVoting {
        uint32 startDate;
        uint32 getSecretPhraseDate;
        uint32 endDate;
    }
    structVoting voting;
    mapping(bool => address[]) votes;// ответы надо шифровать
    mapping(address => bool) usersDb;// todo: в мапинге надо хранить хеш голосов
    mapping(bytes32 => address) hashBd;

    event XXX(uint256);
    event voteX(bool _vote, bytes32 _word);

    constructor(uint32 _startDate, uint32 _getSecretPhaseDate, uint32 _endDate) public{
        voting = structVoting(_startDate, _getSecretPhaseDate, _endDate);
    }

    // todo: добавить шифрование в массив
    // add: добавил string который используется для шифрования голоса
    function vote(bytes32 _voteHash) public {
        require(voting.startDate <= now);
        require(voting.endDate >= now);
        require(usersDb[msg.sender] != true);

        usersDb[msg.sender] = true; // помечаем кто проголосовал
        hashBd[_voteHash] = msg.sender;
    }

    function hashVote(bool _vote, bytes32 _word) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_vote, _word));
    }

    function openvote(bool _vote, bytes32 _word) public {
        require(voting.endDate <= now);
        require(usersDb[msg.sender]);

        if (hashBd[hashVote(_vote, _word)] == msg.sender){
            votes[_vote].push(msg.sender);
        }
    }

    function stats() public view returns (uint, uint) {
        address[] memory _arrayVotesNo = votes[false];
        address[] memory _arrayVotesYes = votes[true];
        uint no = _arrayVotesNo.length;
        uint yes = _arrayVotesYes.length;

        return (no, yes);

    }

}

