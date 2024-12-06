#!/bin/env bash

export PRIVKEY="acd347414c6fbee2e510eca0a9abdcd9a8f047a6bb7a4fcc63fa50cf8de8e580"
export RPC_URL="https://ethereum-sepolia.core.chainstack.com/dcb7fb3f2e082b3891dc065a746d0cc3"
export HACK_ADDR="0x42A2D327f46a912f532AD8ac90D5b0683CE748E5"
export COINFLIP_ADDR="0x18e8659E7e0d94468915C92194f9038989912497"

for i in {1..10}; do
    while true; do
        cast send --rpc-url=$RPC_URL --private-key=$PRIVKEY $HACK_ADDR $(cast calldata 'doGuess()')
        if [[ $? -ne 0 ]]; then
            echo "Transaction failed"
        else
            break;
        fi
    done;
    cast call --rpc-url=$RPC_URL $COINFLIP_ADDR "consecutiveWins()"
done;
