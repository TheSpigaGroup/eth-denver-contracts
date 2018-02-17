pragma solidity ^0.4.19;
import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract TokenMeta {
  struct Meta {
    address issuer;
    uint created;
    bool approved;
    bool finished;
  }
  struct Location {
    int lat;
    int long;
  }

  mapping (uint256 => Meta) internal tokenMeta;
  mapping (uint256 => Location[]) internal transferLocations;
  mapping (uint256 => uint[]) internal transferTimes;

  function getIssuer(uint256 _tokenId) public view returns (address) {
    return tokenMeta[_tokenId].issuer;
  }
  function getTokenApproved(uint256 _tokenId) public view returns (bool) {
    return tokenMeta[_tokenId].approved;
  }
  function getCreated(uint256 _tokenId) public view returns (uint) {
    return tokenMeta[_tokenId].created;
  }
  function getFinished(uint256 _tokenId) public view returns (bool) {
    return tokenMeta[_tokenId].finished;
  }
  function getTransferLocations(uint256 _tokenId) public view returns ((int, int)[]) {
    return transferLocations[_tokenId];
  }
  function getTransferTimes(uint256 _tokenId) public view returns (uint[]) {
    return transferTimes[_tokenId];
  }
}
