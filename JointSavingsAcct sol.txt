pragma solidity ^0.7.0;
//SPDX-License-Identifier: UNLICENSED
contract JointSavingsAccount {
    
    address payable accountSpouse1;
    address payable accountSpouse2; 

    address public last_to_withdraw;
    uint public last_withdraw_block;
    uint public last_withdraw_amount;

    address public last_to_deposit;
    uint public last_deposit_block;
    uint public last_deposit_amount;

    uint unlock_time;
    //constructor
    constructor(address payable AccountforSpouse1, address payable AccountforSpouse2) {
        accountSpouse1 = AccountforSpouse1;
        accountSpouse2 = AccountforSpouse2;
  }

 
//withdraw
  function withdraw(uint amount) public {
    require(unlock_time < block.timestamp,
        "Account is locked!");
    require(msg.sender == accountSpouse1 || msg.sender == accountSpouse2, "You don't own this account!");

    if (last_to_withdraw != msg.sender) {
      last_to_withdraw = msg.sender;
    }

    last_withdraw_block = block.number;
    last_withdraw_amount = amount;

    if (amount > address(this).balance / 4) {
      unlock_time = block.timestamp + 24 hours;
    }

    msg.sender.transfer(amount);
  }
    //deposit   
  function deposit() public payable {

    if (last_to_deposit != msg.sender) {
      last_to_deposit = msg.sender;
    }

    last_deposit_block = block.number;
    last_deposit_amount = msg.value;
  }
  receive() external payable {}
  
  fallback() external payable {}
}
