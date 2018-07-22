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

    function makeOrder(uint _cost, uint _time) public {
        allOrders[msg.sender] = order(_cost, _time, false);
    }
    
    function compliteOrder(address _user) public {
        // todo: сделать, чтобы деньги переводились только с owner
        transfer(_user, 1);
        allOrders[msg.sender].done = true;
    }



//
//    function freeze(uint thawTS) public {
//        require(m_freeze_info[msg.sender] <= now);
//        m_freeze_info[msg.sender] = thawTS;
//    }
//
//    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
//        require(m_freeze_info[_from] <= now);
//        return super.transferFrom(_from, _to, _value);
//
//    }
//
//    function transfer(address _to, uint256 _value) public returns (bool) {
//        require(m_freeze_info[msg.sender] <= now);
//        return super.transfer(_to, _value);
//    }
//
//    mapping (address => uint) public m_freeze_info;
}
