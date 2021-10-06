// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
building out mining function:
  a. nft points to an address
  b. keep track of token ids
  c. keep track of token owners to token ids
  d. keep track of how many token owner address has
  e. create an event that enits a transfer log
     contract address, where it is being minted to, the id
*/

contract ERC721 {
  mapping (uint256 => address) private _tokenOwner;
  mapping (address => uint256) private _ownedTokensCount;

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenID
  );

  function balanceOf(address _owner) public view returns(uint256 balance) {
    require(_owner != address(0), "ERC721: balance to the zero address");
    return _ownedTokensCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns(address owner) {
    address _owner = _tokenOwner[_tokenId];
    require(_owner != address(0), "ERC721: owner to the zero address");
    return _owner;
  }

  function _tokenExist(uint256 _tokenID) internal view returns(bool exist) {
    address _owner = _tokenOwner[_tokenID];

    return _owner != address(0);
  }

  function _mint(address _to, uint256 _tokenId) internal virtual {
    require(_to != address(0), "ERC721: minting to the zero address");
    require(!_tokenExist(_tokenId), "ERC721: Token already minted");

    _tokenOwner[_tokenId] = _to;
    _ownedTokensCount[_to] += 1;

    emit Transfer(address(0), _to, _tokenId);
  }
}