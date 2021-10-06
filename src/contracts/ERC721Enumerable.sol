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
    
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) view public returns (uint256 tokenId) {
    
  }

  function _mint(address _to, uint256 _tokenId) internal override(ERC721) {
    super._mint(_to, _tokenId);

    _addTokensToTotalSupply(_tokenId);
  }

  function _addTokensToTotalSupply(uint256 _tokenId) private {
   _allTokens.push(_tokenId); 
  }
}