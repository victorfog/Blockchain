pragma solidity ^0.4.24;

//import "./ERC721Basic.sol";
import "./Ownable.sol";

contract Ticket is Ownable {
    uint public allTicket = 206;
    uint constant ticketPrice = 15 finney;
    bool isStart = false;
    address selfAddress;

// todo: структура битета владелец, тип, Idбилета, и еще что-то там
//    struct ticket{
//
//    }

    constructor() public Ownable() {}

    modifier isStarted() {
        require(isStart == true);
        _;
    }

    function start(address _selfAddress) onlyOwner public { //
        require(isStart == false);
        isStart = true;
        selfAddress = _selfAddress;
    }

    function withdraw() onlyOwner public {
        owner.transfer(selfAddress.balance);
    }

    mapping (address => bytes32[]) soul;

    function buy(address _owner, uint _numberOfTickets) payable isStarted public {
        require(_numberOfTickets > 0, "xxx");
        require(_numberOfTickets <= allTicket, "yyy");
        uint _cost = calculatePrice(_numberOfTickets);
        require(msg.value >= _cost, "zzz");

        _owner = msg.sender;

        for(uint i = 0; i < _numberOfTickets; i++) {
            bytes32 token = hash(_owner, allTicket); // remove _numberOfTickets
            soul[_owner].push(token);
            allTicket--;
        }
    }

    function calculatePrice(uint _numberOfTickets) public pure returns(uint) {
        return _numberOfTickets * ticketPrice;
    }

    function hash(address _owner, uint _allTicket) public view returns(bytes32) { //remove uint _numberOfTickets; pure to view
        return keccak256(abi.encodePacked(_owner, _allTicket, selfAddress)); //remplace _numberOfTickets to _allTicket
    }

    function test(bytes32 _ticketId, address _ticketOwn) public view returns(bool){
        //bool ansver = false;
        bytes32[] memory _ticketList = soul[_ticketOwn];
        for(uint i = 0; i< _ticketList.length; i++ ) {
            if(_ticketList[i] == _ticketId){
                return true;
            }
        }
        return false;
    }
}
