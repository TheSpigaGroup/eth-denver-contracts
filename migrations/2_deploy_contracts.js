// eslint-disable-next-line no-undef
const CustodyChain = artifacts.require("./CustodyChain.sol");

module.exports = deployer => {
  deployer.deploy(CustodyChain);
};
