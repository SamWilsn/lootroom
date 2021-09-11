// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;
import "ds-test/test.sol";

import "../../LootRoom.sol";
import "./Hevm.sol";

contract TestLootRoom is LootRoom {
    function linkEastWest(uint256 eastern, uint256 western) public {
        _linkEastWest(eastern, western);
    }

    function linkNorthSouth(uint256 northern, uint256 southern) public {
        _linkNorthSouth(northern, southern);
    }
}

contract LootRoomTest is DSTest {
    Hevm internal constant hevm =
        Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // contracts
    TestLootRoom internal lootRoom;

    function setUp() public virtual {
        lootRoom = new TestLootRoom();
    }
}
