// Import libraries
const Web3 = require('web3');
const contract = require('truffle-contract');
const Token = require('./build/contracts/Token.json');

// Setup RPC connection
const provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');

// Read JSON and attach RPC connection (Provider)
const token = contract(Token);
token.setProvider(provider);

token.currentProvider.sendAsync = function () {
  return token.currentProvider.send.apply(token.currentProvider, arguments);
};

// Use Truffle as usual
token.deployed().then(instance => {
  console.log(instance);
  return instance;
}).then(result => {
  console.log(result);
}).catch(err => {
  console.log(err);
});
