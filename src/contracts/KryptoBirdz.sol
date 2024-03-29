// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {
  string[] public kryptoBirdz;
  mapping (string => bool) _kryptoBirdzExists;

  constructor () ERC721Connector('KryptoBird','KBIRDZ') {}

  function mint(string memory _kryptoBird) public {
    require(!_kryptoBirdzExists[_kryptoBird], "Error: KryptoBird already exist");

    kryptoBirdz.push(_kryptoBird);
    uint256 _id = kryptoBirdz.length - 1;

    _mint(msg.sender, _id);
    _kryptoBirdzExists[_kryptoBird] = true;
  }
}