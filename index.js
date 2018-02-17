// Import libraries
const Web3 = require('web3');
const BigNumber = require('bignumber.js');
const contract = require('truffle-contract');
const Token = require('./build/contracts/Token.json');
const keys = require('./keys.json');

// Setup RPC connection
const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');

// Read JSON and attach RPC connection (Provider)
const token = contract(Token);
token.setProvider(provider);

token.currentProvider.sendAsync = function () {
  return token.currentProvider.send.apply(token.currentProvider, arguments);
};

// Use Truffle as usual
token.deployed().then(instance => {
  console.log(Object.keys(keys.addresses)[0]);
  return instance.startCustody(Object.keys(keys.addresses)[0].split('x')[1], new BigNumber("2134"));
}).then(result => {
  console.log(result);
}).catch(err => {
  console.log(err);
});
