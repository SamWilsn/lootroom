// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;
import "ds-test/test.sol";

import "../../LootRoomToken.sol";
import "./Hevm.sol";

contract TestLootRoomToken is LootRoomToken {
    constructor(LootRoom render, IERC721 loot) LootRoomToken(render, loot) {
    }
}

contract MockLoot is ERC721 {
    constructor() ERC721("MockLoot", "MLOOT") {
    }

    function mint(address to, uint256 tokenId) external returns (uint256) {
        _mint(to, tokenId);
        return tokenId;
    }
}

contract LootRoomTokenTest is DSTest {
    Hevm internal constant hevm =
        Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // contracts
    LootRoom internal render;
    MockLoot internal mockLoot;
    TestLootRoomToken internal lootRoomToken;

    // Loot bags
    uint256 internal myBag;
    uint256 internal otherBag;

    function setUp() public virtual {
        mockLoot = new MockLoot();
        render = new LootRoom();

        myBag = mockLoot.mint(address(this), 0x1);
        otherBag = mockLoot.mint(address(hevm), 0x2);

        lootRoomToken = new TestLootRoomToken(render, mockLoot);
    }
}
