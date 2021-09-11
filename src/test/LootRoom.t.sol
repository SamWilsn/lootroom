// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

import "./utils/LootRoomTest.sol";
import {LootRoomErrors} from "../LootRoom.sol";

contract RoomLinks is LootRoomTest {
    function testLinkEastWest() public {
        uint256 eastern = 45;
        uint256 western = 66;

        lootRoom.linkEastWest(eastern, western);

        assertEq(lootRoom.westOf(eastern), western);
        assertEq(lootRoom.northOf(eastern), 0);
        assertEq(lootRoom.eastOf(eastern), 0);
        assertEq(lootRoom.southOf(eastern), 0);

        assertEq(lootRoom.southOf(western), 0);
        assertEq(lootRoom.eastOf(western), eastern);
        assertEq(lootRoom.northOf(western), 0);
        assertEq(lootRoom.westOf(western), 0);
    }

    function testLinkNorthSouth() public {
        uint256 northern = 45;
        uint256 southern = 66;

        lootRoom.linkNorthSouth(northern, southern);

        assertEq(lootRoom.southOf(northern), southern);
        assertEq(lootRoom.northOf(northern), 0);
        assertEq(lootRoom.eastOf(northern), 0);
        assertEq(lootRoom.westOf(northern), 0);

        assertEq(lootRoom.southOf(southern), 0);
        assertEq(lootRoom.northOf(southern), northern);
        assertEq(lootRoom.eastOf(southern), 0);
        assertEq(lootRoom.westOf(southern), 0);
    }

    /*
    function testOwnerCannotGmOnBadBlocks() public {
        try alice.gm() { fail(); } catch Error(string memory error) {
            assertEq(error, Errors.InvalidBlockNumber);
        }
    }
    */
}
