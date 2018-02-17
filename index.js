// Import libraries
const Web3 = require('web3');
const BigNumber = require('bignumber.js');
const contract = require('truffle-contract');
const CustodyToken = require('./build/contracts/CustodyToken.json');
const keys = require('./keys.json');

// Setup RPC connection
const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
const web3 = new Web3(provider);

// Read JSON and attach RPC connection (Provider)
const token = contract(CustodyToken);
token.setProvider(provider);

token.currentProvider.sendAsync = function () {
  return token.currentProvider.send.apply(token.currentProvider, arguments);
};

const accounts = Object.keys(keys.addresses);

let thisToken = null;

token.deployed().then(instance => {
  thisToken = instance;
  web3.eth.defaultAddress = instance.address;

  // return(instance.name());

  const whiteListed = [];
  accounts.forEach(acct => {
    whiteListed.push(acct);
  });

  // return instance.startCustody(12346, { from: accounts[0], gas: 1000000 });
  return instance.setWhiteList(whiteListed, { from: accounts[0], gas: 1000000 });
}).then(result => {
  console.log(result);
  // return thisToken.getWhiteList({ from: accounts[0], gas: 1000000 });
  return null;
}).then(mass => {
  console.log(mass);
}).catch(err => {
  console.log(err);
});
