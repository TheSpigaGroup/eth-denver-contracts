// eslint-disable-next-line no-undef
const CustodyToken = artifacts.require("./CustodyToken.sol");

module.exports = deployer => {
  deployer.deploy(CustodyToken);
};
