pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import './TokenMeta.sol';

contract CustodyChain is ERC721Token, TokenMeta {

  string constant private tokenName = "CustodyChain";
  string constant private tokenSymbol = "CUS";
  uint256 private tokenId = 1;

  // Whitelist map
  mapping (address => bool) internal wList;
  // Whitelist array for queries
  address[] internal wListAddrs;

  // Only allow custodychain issuer
  modifier onlyIssuerOf(uint256 _tokenId) {
    require(tokenMeta[_tokenId].issuer == msg.sender);
      _;
  }

  // Mint token for trustee, add to whitelist validTokens (return token id?)
  // function startCustody(address[] _whiteListAddrs)) public returns (uint256) {
  function startCustody() public returns (uint256) {
    // No tokenId provided, create one
    tokenId++;
    // Mint new CustodyChain
    _mint(msg.sender, tokenId);
    // Add metadata to token
    tokenMeta[tokenId] = Meta({
      issuer: msg.sender,
      created: now,
      approved: 0,
      finished: false,
      tampered: false
    });
    // Send back the new ID
    return tokenId;
  }

  // Start CustodyChain with a custom tokenId
  function startCustody(uint256 _tokenId) public returns (uint256) {
    // Mint new CustodyChain
    _mint(msg.sender, _tokenId);
    // Add metadata to token
    tokenMeta[tokenId] = Meta({
      issuer: msg.sender,
      created: now,
      approved: 0,
      finished: false,
      tampered: false
    });
    return _tokenId;
  }


  // Function to allow a chain of custody to occur
  function approveCustody(uint _tokenId, bool approved) public onlyOwnerOf(_tokenId) onlyIssuerOf(_tokenId) {
    // If approved, timestamp, otherwise destroy the token
    if (approved) {
      tokenMeta[_tokenId].approved = now;
    } else {
      _burn(_tokenId);
    }
  }

  // Burn token for trustee, remove from whitelist validTokens
  function endCustody(uint256 _tokenId) onlyOwnerOf(_tokenId) public {
    // Go into lockup
    tokenMeta[_tokenId].finished = true;
  }
  // Burn token for trustee, remove from whitelist validTokens
  function reportBadActor(uint256 _tokenId) onlyIssuerOf(_tokenId) public {
    // Go into lockup
    tokenMeta[_tokenId].finished = true;
    tokenMeta[_tokenId].tampered = true;
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
    // Check if _to is approved
    require(wList[_to]);
    // Make sure state is correct
    require(!tokenMeta[_tokenId].finished && tokenMeta[_tokenId].approved > 0);
    // Add transfer location to metadata
    transferLocations[_tokenId].push(Location({lat: _lat, long: _long}));
    // Add transfer time to metadata
    transferTimes[_tokenId].push(now);
    // Transfer token
    super.transfer(_to, _tokenId);
    // Check if reciever is the original issuer
    if (tokenMeta[_tokenId].issuer == _to) {
      // Finish chain of custody
      endCustody(_tokenId);
    }
  }
  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    require(wList[_to]);
    require(!tokenMeta[_tokenId].finished && tokenMeta[_tokenId].approved > 0);
    transferLocations[_tokenId].push(Location({lat: 0, long: 0}));
    transferTimes[_tokenId].push(now);
    super.transfer(_to, _tokenId);
  }

  function name() pure public returns (string) {
    return tokenName;
  }
}
