// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15; 

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

contract HTLC {
  uint public startTime;
  uint public lockTime = 10000 seconds;
  string public secret; //swapping
  bytes32 public hash = 0x41da7906f272f1c9ac1e8c4c32085b2551301d37ce2001a8896fb2868ec3d063;
  address public recipient;
  address public owner; 
  uint public amount; 
  IERC20 public token;

  constructor(address _recipient, address _token, uint _amount) { 
    recipient = _recipient;
    owner = msg.sender; 
    amount = _amount;
    token = IERC20(_token);
  } 

  function fund() external {
    startTime = block.timestamp;
    token.transferFrom(msg.sender, address(this), amount);
  }

  function withdraw(string memory _secret) external { 
    require(keccak256(abi.encodePacked(_secret)) == hash, 'wrong secret');
    secret = _secret; 
    token.transfer(recipient, amount); 
  } 

  function refund() external { 
    require(block.timestamp > startTime + lockTime, 'too early');
    token.transfer(owner, amount); 
  } 
}
