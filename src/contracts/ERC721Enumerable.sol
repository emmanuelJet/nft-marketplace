// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {
  uint256[] private _allTokens;

  // Mapping from tokenId to position on _allTokens array
  mapping (uint256 => uint256) private _allTokensIndex;
  // Mapping of owner to list of all owner token ids
  mapping (address => uint256[]) private _ownedTokens;
  // Mapping from tokenId index of the owner tokens list
  mapping (uint256 => uint256) private _ownedTokensIndex;

  function totalSupply() view public returns (uint supply) {
    return _allTokens.length;
  }

  function tokenByIndex(uint256 _index) view public returns (uint256 tokenId) {
    require(_index <= totalSupply(), "Global token index is out of bounds!");
    return _allTokens[_index];
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) view public returns (uint256 ownerTokenId) {
    require(_index <= balanceOf(_owner), "Owner token index is out of bounds!");
    return _ownedTokens[_owner][_index];
  }

  function _mint(address _to, uint256 _tokenId) internal override(ERC721) {
    super._mint(_to, _tokenId);

    _addTokensToAllTokenEnumeration(_tokenId);
    _addTokensToOwnerEnumeration(_to, _tokenId);
  }

  function _addTokensToAllTokenEnumeration(uint256 _tokenId) private {
    _allTokensIndex[_tokenId] = _allTokens.length;
    _allTokens.push(_tokenId);
  }

  function _addTokensToOwnerEnumeration(address _owner, uint256 _tokenId) private {
    _ownedTokensIndex[_tokenId] = _ownedTokens[_owner].length;
    _ownedTokens[_owner].push(_tokenId);
  }
}