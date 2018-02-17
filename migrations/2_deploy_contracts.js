// eslint-ignore-no-undef
// const Issuer = artifacts.require('./Issuer.sol');
const Token = artifacts.require("./Token.sol");

module.exports = deployer => {
  // deployer.deploy(Issuer);
  deployer.deploy(Token);
};
