// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x2aa3f471.

interface IERC721Enumerable {
  function totalSupply() external view returns (uint256 supply);
  function tokenByIndex(uint256 _index) external view returns (uint256 tokenId);
  function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 ownerTokenId);
}