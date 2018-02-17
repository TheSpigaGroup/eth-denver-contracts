pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract CustodyToken is ERC721Token {

  string constant private tokenName = "CustodyToken";
  string constant private tokenSymbol = "CTD";
  uint256 private tokenId = 1;

  function name() public constant returns (string) {
    return tokenName;
  }

  // CustodyToken whitelisted addresses
  struct WhiteList {
    address _address;
    uint256[] validTokens;
  }
  WhiteList[] whiteList;

  // Mint token for trustee, add to whitelist validTokens (return token id?)
  function startCustody(uint256 _tokenId) public {
    tokenId++;
    _mint(msg.sender, tokenId);
  }

  // Burn token for trustee, remove from whitelist validTokens
  function endCustody() public {
  }

  // Add OR remove address(es) in whitelist
  // TODO: Add remove capability
  function setWhiteList(address[] _list) public {
    for (uint i=0; i<_list.length-1; i++) {
      uint256[] memory tokens;
      WhiteList memory tmp = WhiteList({
        _address: _list[i],
        validTokens: tokens
       });
      whiteList.push(tmp);
    }
  }

  // Get whitelist (something wrong...)
  function getWhiteList() public returns (WhiteList[]) {
    return whiteList;
  }

  function approve(bool approved, uint256 _tokenId) public view onlyOwnerOf(_tokenId) {
    require(approved);
  }
}
