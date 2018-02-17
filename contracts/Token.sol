pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract Token is ERC721Token {
  string constant private tokenName = "My ERC721 Token";
  string constant private tokenSymbol = "MET";
  /* event StartCustody(address indexed _to, uint256 indexed _tokenId); */

  function name() public constant returns (string) {
    return tokenName;
  }

  function startCustody(address _target, uint256 _tokenId) public {
    _mint(_target, _tokenId);
    /* StartCustody(msg.sender, _tokenId); */
  }

  function approve(bool approved, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    require(approved);
  }
}
