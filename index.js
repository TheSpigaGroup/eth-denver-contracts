const Web3 = require('web3');
const contract = require('truffle-contract');
const CustodyChain = require('./build/contracts/CustodyChain.json');
const keys = require('./keys.json');

const provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');

const token = contract(CustodyChain);
token.setProvider(provider);

token.currentProvider.sendAsync = function () {
  return token.currentProvider.send.apply(token.currentProvider, arguments);
};

const accounts = Object.keys(keys.addresses);
let thisToken = null;
let tId;

token.deployed()
  .then(instance => {
    thisToken = instance;

    /** Set up whitelist
     * There are five total accounts created/used
     *
     * Regarding the UI demo...
     * accounts[0] is issuer, accounts[1] is trustee, accounts[2/3] are custodians,
     * accounts[4] is bad actor
     */
    const whiteListed = accounts.slice(0, 4);
    console.log(whiteListed);
    return instance.setWhiteList(whiteListed, { from: accounts[0], gas: 1000000 });
  })
  .then(() => thisToken.getWhiteList({ from: accounts[0], gas: 1000000 }))
  .catch(err => {
    console.log(err);
  });
