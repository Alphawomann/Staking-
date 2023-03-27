// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;  

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract staking is ERC20{

mapping(address => uint) public staked; //to capture the address and amount people will stake
mapping(address => uint) private stakedFromTS; //capturing the time a person staked into the contract

constructor() ERC20("Dera Token", "DTK"){ //to permanently save the name of the token and symbol
_mint(msg.sender, 10**18); //mint function predefined in the imported openzeppelin code 
//the account/address of the person (maybe developer) where the money will be minted into
}

function stake(uint amount) public { //captures the amount of money to be staked
require(amount > 0, "amount is < = 0"); //a requirement to be sure the amount to be staked is >0
require(balanceOf(msg.sender) >= amount, "You do not have up to that amount");
//checking the balance of the person that wants to stake, to be sure it's greater than the amount the person wants to stake
_transfer(msg.sender, address(this), amount); //the owner, where the money is going to, and amount

if (staked[msg.sender] > 0){ //if the money staked is > o, then you can claim
claim();
}

stakedFromTS[msg.sender] = block.timestamp; //this captures the time you staked
staked[msg.sender] = staked[msg.sender] + amount; //adding the amount staked to the address of the msg.sender
}

function unstake(uint amount) public{ 
require(amount > 0, "amount < = 0"); //the amount to unstake must be greater than 0
require(staked[msg.sender] > 0, "You did not stake with us"); //to be sure the person staked more than 0 with us
_transfer(address(this), msg.sender, amount);
//captures the transfer from the contract address, the person that staked and the amount staked

stakedFromTS[msg.sender] = block.timestamp; //to help capture the staked time
staked[msg.sender] = staked[msg.sender] - amount; //deducting the money staked

}

function claim() public{
require(staked[msg.sender] > 0, "You did not stake with us"); //to be sure the caller has a stake here
uint secondsStaked = block.timestamp - stakedFromTS[msg.sender]; //to get the total amount of time staked,
//we have to subtract the time that you stake from now. This is so we can know how long you staked 
//and how much your reward is. Then we saved it up in secondsStaked. 

uint rewards = staked[msg.sender] * secondsStaked / 3.154e7; //the amount staked * second staked / a year
_mint(msg.sender, rewards);  // this shows the account we're minting to and the rewwardsamount
stakedFromTS[msg.sender] = block.timestamp; //updating the status of the time the reward was claimed 
}

}


   