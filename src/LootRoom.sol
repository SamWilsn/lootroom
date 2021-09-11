// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

library LootRoomErrors {
    string constant NO_EXIT = "no exit";
    string constant ALREADY_LINKED = "already linked";
}

abstract contract LootRoom {
    uint256 constant private NO_EXIT = type(uint256).max;

    struct Room {
        uint256 north;
        uint256 east;
        uint256 south;
        uint256 west;
    }

    mapping (uint256 => Room) private s_Rooms;

    function _initializeRoom(
        uint256 tokenId,
        bool openNorth,
        bool openEast,
        bool openSouth,
        bool openWest
    ) internal {
        Room storage room = s_Rooms[tokenId];
        room.north = openNorth ? 0 : NO_EXIT;
        room.east  = openEast  ? 0 : NO_EXIT;
        room.south = openSouth ? 0 : NO_EXIT;
        room.west  = openWest  ? 0 : NO_EXIT;
    }

    function northOf(uint256 tokenId) public view returns (uint256) {
        uint256 id = s_Rooms[tokenId].north;
        require(NO_EXIT != id, LootRoomErrors.NO_EXIT);
        return id;
    }

    function eastOf(uint256 tokenId) public view returns (uint256) {
        uint256 id = s_Rooms[tokenId].east;
        require(NO_EXIT != id, LootRoomErrors.NO_EXIT);
        return id;
    }

    function southOf(uint256 tokenId) public view returns (uint256) {
        uint256 id = s_Rooms[tokenId].south;
        require(NO_EXIT != id, LootRoomErrors.NO_EXIT);
        return id;
    }

    function westOf(uint256 tokenId) public view returns (uint256) {
        uint256 id = s_Rooms[tokenId].west;
        require(NO_EXIT != id, LootRoomErrors.NO_EXIT);
        return id;
    }

    function _linkNorthSouth(uint256 northern, uint256 southern) internal {
        require(NO_EXIT != northern && NO_EXIT != southern, LootRoomErrors.NO_EXIT);

        require(0 == s_Rooms[northern].south, LootRoomErrors.ALREADY_LINKED);
        require(0 == s_Rooms[southern].north, LootRoomErrors.ALREADY_LINKED);

        s_Rooms[northern].south = southern;
        s_Rooms[southern].north = northern;
    }

    function _linkEastWest(uint256 eastern, uint256 western) internal {
        require(NO_EXIT != eastern && NO_EXIT != western, LootRoomErrors.NO_EXIT);

        require(0 == s_Rooms[eastern].west, LootRoomErrors.ALREADY_LINKED);
        require(0 == s_Rooms[western].east, LootRoomErrors.ALREADY_LINKED);

        s_Rooms[eastern].west = western;
        s_Rooms[western].east = eastern;
    }

    function _unlinkNorth(uint256 southern) internal {
        uint256 northern = s_Rooms[southern].north;
        require(NO_EXIT != northern, LootRoomErrors.NO_EXIT);
        s_Rooms[southern].north = 0;
        s_Rooms[northern].south = 0;
    }

    function _unlinkSouth(uint256 northern) internal {
        uint256 southern = s_Rooms[northern].south;
        require(NO_EXIT != southern, LootRoomErrors.NO_EXIT);
        s_Rooms[northern].south = 0;
        s_Rooms[southern].north = 0;
    }

    function _unlinkWest(uint256 eastern) internal {
        uint256 western = s_Rooms[eastern].west;
        require(NO_EXIT != western, LootRoomErrors.NO_EXIT);
        s_Rooms[eastern].west = 0;
        s_Rooms[western].east = 0;
    }

    function _unlinkEast(uint256 western) internal {
        uint256 eastern = s_Rooms[western].east;
        require(NO_EXIT != eastern, LootRoomErrors.NO_EXIT);
        s_Rooms[western].east = 0;
        s_Rooms[eastern].west = 0;
    }
}
