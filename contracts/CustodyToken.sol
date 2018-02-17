pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import './TokenMeta.sol';

contract CustodyToken is ERC721Token, TokenMeta {

  string constant private tokenName = "CustodyToken";
  string constant private tokenSymbol = "CTD";
  uint256 private tokenId = 1;

  mapping (address => bool) internal wList;
  address[] internal wListAddrs;

  // Mint token for trustee, add to whitelist validTokens (return token id?)
  // function startCustody(address[] _whiteListAddrs)) public returns (uint256) {
  function startCustody() public returns (uint256) {
    tokenId++;
    _mint(msg.sender, tokenId);
    tokenMeta[tokenId] = Meta({
      issuer: msg.sender,
      created: now,
      approved: false,
      finished: false
    });
    return tokenId;
  }

  // Burn token for trustee, remove from whitelist validTokens
  function endCustody(uint256 _tokenId) onlyOwnerOf(_tokenId) public {
    _burn(_tokenId);
  }

  // Add address(es) in whitelist
  function setWhiteList(address[] _list) public {
    for (uint i=0; i<_list.length-1; i++) {
      wList[_list[i]] = true;
    }
    wListAddrs = _list;
  }

  // Get whitelist address
  function getWhiteList() public view returns (address[]) {
    return wListAddrs;
  }


  function transfer(address _to, uint256 _tokenId, int _lat, int _long) public onlyOwnerOf(_tokenId) {
    require(wList[_to]);
    transferLocations[_tokenId].push(Location({lat: _lat, long: _long}));
    transferTimes[_tokenId].push(now);
    super.transfer(_to, _tokenId);
  }
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    require(wList[_to]);
    transferLocations[_tokenId].push(Location({lat: 0, long: 0}));
    transferTimes[_tokenId].push(now);
    super.transfer(_to, _tokenId);
  }

  function name() pure public returns (string) {
    return tokenName;
  }
}
