// Import libraries
const Web3 = require('web3');
const BigNumber = require('bignumber.js');
const contract = require('truffle-contract');
const CustodyToken = require('./build/contracts/CustodyToken.json');
const keys = require('./keys.json');

// Setup RPC connection
const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');

// Read JSON and attach RPC connection (Provider)
const token = contract(CustodyToken);
token.setProvider(provider);

token.currentProvider.sendAsync =  function () {
  return token.currentProvider.send.apply(token.currentProvider, arguments);
};


const accounts = Object.keys(keys.addresses);

let thisToken = null;
let tId;

token.deployed().then(instance => {
  thisToken = instance;

  const whiteListed = accounts.slice(0, 5);
  return instance.setWhiteList(whiteListed, { from: accounts[0], gas: 1000000 });
}).then(result => {
  return thisToken.getWhiteList({ from: accounts[0], gas: 1000000 });
}).then(result => {
  return thisToken.startCustody({ from: accounts[0], gas: 1000000 });
}).then(result => {
  return thisToken.tokensOf(accounts[0], { from: accounts[0], gas: 1000000 });
}).then(result => {
  // console.log(result.toString(10));
  tId = new BigNumber(result[0]);
  return thisToken.transfer(accounts[2], tId, 10, 40, { from: accounts[0], gas: 1000000 });
}).then(result => {
  return thisToken.getTransferLocations(tId, { from: accounts[0], gas: 1000000 });
  // console.log(result.logs);
  // return thisToken.balanceOf(accounts[0], { from: accounts[0], gas: 1000000 });
}).then(result => {
  // console.log(result.toString(10));
// }).then(result => {
})
  .catch(err => {
    console.log(err);
  });
