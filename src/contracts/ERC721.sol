// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';

/*
building out mining function:
  a. nft points to an address
  b. keep track of token ids
  c. keep track of token owners to token ids
  d. keep track of how many token owner address has
  e. create an event that enits a transfer log
     contract address, where it is being minted to, the id
*/

contract ERC721 is ERC165, IERC721 {
  mapping (uint256 => address) private _tokenOwner;
  mapping (address => uint256) private _ownedTokensCount;
  mapping (uint256 => address) private _tokenApprovals;

  constructor () {
    _registerInterface(bytes4(
      keccak256('balanceOf(bytes4)')^
      keccak256('ownerOf(bytes4)')^
      keccak256('transferFrom(bytes4)')
    ));
  }

  function balanceOf(address _owner) public override view returns(uint256 balance) {
    require(_owner != address(0), "ERC721: balance to the zero address");
    return _ownedTokensCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public override view returns(address owner) {
    address _owner = _tokenOwner[_tokenId];
    require(_owner != address(0), "ERC721: owner to the zero address");
    return _owner;
  }

  function _tokenExist(uint256 _tokenId) internal view returns(bool exist) {
    address _owner = _tokenOwner[_tokenId];

    return _owner != address(0);
  }

  function _mint(address _to, uint256 _tokenId) internal virtual {
    require(_to != address(0), "ERC721: minting to the zero address");
    require(!_tokenExist(_tokenId), "ERC721: Token already minted");

    _tokenOwner[_tokenId] = _to;
    _ownedTokensCount[_to] += 1;

    emit Transfer(address(0), _to, _tokenId);
  }

  function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0), "ERC721: transfer to the zero address");
    require(ownerOf(_tokenId) == _from, "ERC721: Trying to transfer an unowned token");

    _ownedTokensCount[_from] -= 1;
    _ownedTokensCount[_to] += 1;

    _tokenOwner[_tokenId] = _to;

    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public override {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _transferFrom(_from, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public {
    address _owner = ownerOf(_tokenId);

    require(_to != _owner, "Error - Approval to Current Owner");
    require(msg.sender == _owner, "Current Caller is not the token owner");

    _tokenApprovals[_tokenId] = _to;

    emit Approval(_owner, _to, _tokenId);
  }

  function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns(bool status) {
    require(_tokenExist(_tokenId), "ERC721: Token does not exist");

    address _owner = ownerOf(_tokenId);
    return (_spender == _owner);
  }
}