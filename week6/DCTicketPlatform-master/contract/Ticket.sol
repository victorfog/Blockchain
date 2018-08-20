pragma solidity ^0.4.0;

import "./ERC721Basic.sol";
import "./Ownable.sol";

contract Ticket is Ownable {
    address public owner;
    uint public allTicket = 206;
    uint constant ticketPrice = 15 finney;
    bool isStart = false;
    address selfAddress;

// todo: структура битета владелец, тип, Idбилета, и еще что-то там
//    struct ticket{
//
//    }

    //constructor() public Ownable() {} //fixme  ести не собирается раскоментить

    modifier isStarted() {
        require(isStart == true);
        _;
    }

    function start(address _selfAddress) isOwner public {
        require(isStart == false);
        isStart = true;
        selfAddress = _selfAddress;
    }

    mapping (address => bytes32[]) soul;

    function Ticket(address _owner, uint _numberOfTickets) payable isStarted {
        require(_numberOfTickets > 0);
        require(_numberOfTickets <= allTicket);
        require(msg.value >= _cost);

        _cost = _numberOfTickets * ticketPrice;

        _owner = msg.sender;

        for(i = 0; i < _numberOfTickets; i++) {
            token = hashTicket(_owner, allTicket);
            soul[_owner].push(token);
            allTicket--;
        }

    }

    function hashTicket(address _owner, uint _allTicket) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_owner, _numberOfTickets, selfAddress));
    }


    function testTickets(bytes32 _ticketId, address _ticketOwn) public view returns(bool){
        bool ansver = false;
        bytes32[] memory _ticketList = soul[_ticketOwn];
        for(i=0; i< _ticketList.leght; i++ ) {
            if(_ticketList[i] == _ticketId){
                return true;
            }
        }
        return false;
    }

}
