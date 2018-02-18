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
  // function escrow(uint256 _tokenId)  private {

  // }
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

  function transfer(address _to, uint256 _tokenId) public {
    clearApprovalAndTransfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
    address owner = ownerOf(_tokenId);
    require(_to != owner);
    require(wList[_to]);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(isApprovedFor(msg.sender, _tokenId));
    clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
  }

  function ownerOf(uint256 _tokenId) public view returns (address) {
    address owner = wListAddrs[_tokenId];
    require(owner != address(0));
    return owner;
  }
 // function balanceOf(address _owner) public view returns (uint256) {
  //   return ownedTokens[_owner].length;
}