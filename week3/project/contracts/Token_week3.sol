pragma solidity ^0.4.0;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Token_week3 is StandardToken {
    constructor() public {
        balances[msg.sender] = 1000 ether;
        totalSupply_ = balances[msg.sender];
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function freeze(uint thawTS) public {
        require(m_freeze_info[msg.sender] <= now);
        m_freeze_info[msg.sender] = thawTS;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        require(m_freeze_info[_from] <= now);
        return super.transferFrom(_from, _to, _value);

    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(m_freeze_info[msg.sender] <= now);
        return super.transfer(_to, _value);
    }

    mapping (address => uint) public m_freeze_info;
}