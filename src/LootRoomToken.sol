// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@base64-sol/base64.sol";
import "./LootRoom.sol";
import "./Measurable.sol";

contract LootRoomToken is LootRoom, ERC721 {
    constructor() ERC721("Loot Room", "ROOM") {
    }
}
