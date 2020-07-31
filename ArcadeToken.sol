pragma solidity ^0.6.0;
// SPDX-License-Identifier: UNLICENSED

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.1.0/contracts/math/SafeMath.sol";


contract ArcadeToken {
    using SafeMath for uint;

    address payable owner = msg.sender;
    string public symbol = "ARCD";
    uint public exchange_rate = 10;
    uint public fee_rate = 15;  // 0.15% of the ether in the spend trx
    uint public token_rewards_rate = 3;
    uint public maxTokensPerAddress = 125;

    mapping(address => uint) balances;
    mapping(uint => uint) machineBalances;

    function maxOutNumberOfTokens(address tokenHolder, uint trxAmount,
        bool addOrSub) private view returns (uint) {
        if (addOrSub) {
            uint newAmount = balances[tokenHolder].add(trxAmount);
            if (newAmount > maxTokensPerAddress) {
                return maxTokensPerAddress;
            }
            else {
                return newAmount;
            }
        }
        else {
            if (balances[tokenHolder] < trxAmount) {
                return 0;
            }
            else {
                return balances[tokenHolder].sub(trxAmount);
            }
        }
    }

    function sendEthereum(address payable recipient) public payable {
        uint fee = msg.value.mul(fee_rate).div(10000);
        uint tokenreward = msg.value.mul(token_rewards_rate);
        balances[msg.sender] = maxOutNumberOfTokens(msg.sender, tokenreward, true);
        recipient.transfer(msg.value.sub(fee));
        owner.transfer(fee);
    }

    function tokenBalance() public view returns(uint) {
        return balances[msg.sender];
    }

    function transferTokens(address recipient, uint tokenvalue) public {
        balances[msg.sender] = maxOutNumberOfTokens(msg.sender, tokenvalue, false);
        balances[recipient] = maxOutNumberOfTokens(recipient, tokenvalue, true);
    }

    function purchaseTokens() public payable {
        uint tokenvalue = msg.value.mul(exchange_rate);
        balances[msg.sender] = maxOutNumberOfTokens(msg.sender, tokenvalue, true);
        owner.transfer(msg.value);
    }

    function giveTokens(address recipient, uint tokenvalue) public {
        require(msg.sender == owner, "You can't give away tokens, silly.");
        balances[recipient] = maxOutNumberOfTokens(recipient, tokenvalue, true);
    }

    function useToken(uint machineId, uint numTokens) public {
        require(balances[msg.sender] >= numTokens,
            "You don't have enough tokens for this game.");
        balances[msg.sender] = maxOutNumberOfTokens(msg.sender, numTokens, false);
        machineBalances[machineId] = machineBalances[machineId].add(numTokens);
    }

}