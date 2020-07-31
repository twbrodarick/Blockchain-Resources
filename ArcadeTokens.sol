pragma solidity ^0.6.0;
//SPDX-License-Identifier: UNLICENSED

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.1.0/contracts/math/SafeMath.sol";


    contract ArcadeToken {
    using SafeMath for uint;
    
    address payable owner = msg.sender;
    string public symbol = "ARCD";
    uint public exchange_rate = 10;
    uint public fee_rate = 25; //  25 bps
    uint public token_reward_rate =  3; // 3 tokens for every 1 wei spent 
    
    mapping(address => uint) balances;

    function tokenBalance() public view returns(uint) {
        return balances[msg.sender];
    }

    function transferTokens(address recipient, uint tokenvalue) public {
        balances[msg.sender] = balances[msg.sender].sub(tokenvalue);
        balances[recipient] = balances[recipient].add(tokenvalue);

    }

    function purchaseTokens() public payable {
        uint tokenvalue = msg.value.mul(exchange_rate);
        balances[msg.sender] = balances[msg.sender].add(tokenvalue);
        owner.transfer(msg.value);
    }

    function mint(address recipient, uint tokenvalue) public {
        require(msg.sender == owner, "Stay in your lane. No minting for you!");
        balances[recipient] = balances[recipient].add(tokenvalue);
    }

    function sendEther(address payable recipient) public payable {
        uint fee = msg.value.mul(fee_rate).div(10000); // calculate 0.25% from basis points
        uint tokenreward = msg.value.mul(token_reward_rate); // reward 3 points for every wei spent
        balances[msg.sender] = balances[msg.sender].add(tokenreward); // add reward to sender point balance
        recipient.transfer(msg.value.sub(fee)); // send transaction with fee subtracted
        owner.transfer(fee); // send fee to RewardsToken owner
    
    }        
        
        
}        