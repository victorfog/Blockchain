pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";

contract Bonus is BasicToken {

    address public owner;

    constructor() public {
        balances[msg.sender] = 42;
        totalSupply_ = balances[msg.sender];
        owner = msg.sender;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }
    struct order {
        uint cost;
        uint timeToGet;
        bool done;
    }
    mapping (address => order) allOrders;

    function makeOrder(uint _cost, uint _timeToGet) public {
        require(_timeToGet >= now - 1 hours);
        allOrders[msg.sender] = order(_cost, _timeToGet, false);
    }

    function compliteOrder(address _user) public {
        require(msg.sender==owner); //выполняется проверка что msg.sender это владелец контракта
        order storage _order = allOrders[_user]; //создаю _order в который помещаю структуру из массива allOrders по ключу msg.sender
        if (_order.timeToGet >= now - 30 minutes) {
            transfer(_user, 1);
        }

        _order.done = true; //присвоение значения true переменной done структуры order из массива allOrders по ключу msg.sender

    }
}
