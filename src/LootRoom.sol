// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

library LootRoomErrors {
    string constant internal OUT_OF_RANGE = "out of range";
    string constant internal NO_LOOT = "no loot bag";
}

abstract contract LootRoom {
    // Opinion
    // Size
    // Description
    // Material
    // Biome
    // Containers

    function getBiomeName(uint8 val) private pure returns (string memory) {
        if (184 >= val) { return "Room"; }
        if (200 >= val) { return "Pit"; }
        if (216 >= val) { return "Lair"; }
        if (232 >= val) { return "Refuge"; }
        if (243 >= val) { return "Shop"; }
        if (254 >= val) { return "Shrine"; }
        return "Treasury";
    }

    function getBiome(uint256 tokenId) public pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[0]);
        return getBiomeName(val);
    }

    function getMaterial(uint256 tokenId) public pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[1]);

        if (128 >= val) { return "Stone"; }
        if (200 >= val) { return "Wooden"; }
        if (216 >= val) { return "Mud"; }
        if (232 >= val) { return "Brick"; }
        if (243 >= val) { return "Granite"; }
        if (254 >= val) { return "Bone"; }
        return "Marble";
    }

    function getContainer(
        uint256 tokenId,
        uint256 idx
    ) public pure returns (string memory) {
        require(4 > idx, LootRoomErrors.OUT_OF_RANGE);
        uint8 val = uint8(bytes32(tokenId)[2 + idx]);
        // 2, 3, 4, 5

        if (229 >= val) { return ""; }
        if (233 >= val) { return "Barrel"; }
        if (237 >= val) { return "Basket"; }
        if (240 >= val) { return "Bucket"; }
        if (243 >= val) { return "Chest"; }
        if (245 >= val) { return "Coffer"; }
        if (247 >= val) { return "Pouch"; }
        if (249 >= val) { return "Sack"; }
        if (251 >= val) { return "Crate"; }
        if (253 >= val) { return "Shelf"; }
        if (255 >= val) { return "Box"; }
        return "Strongbox";
    }

    function getOpinion(uint256 tokenId) public pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[6]);

        if (229 >= val) { return "Unremarkable"; }
        if (233 >= val) { return "Unusual"; }
        if (237 >= val) { return "Interesting"; }
        if (240 >= val) { return "Strange"; }
        if (243 >= val) { return "Bizarre"; }
        if (245 >= val) { return "Curious"; }
        if (247 >= val) { return "Memorable"; }
        if (249 >= val) { return "Remarkable"; }
        if (251 >= val) { return "Notable"; }
        if (253 >= val) { return "Peculiar"; }
        if (255 >= val) { return "Puzzling"; }
        return "Weird";
    }

    function getSize(uint256 tokenId) public pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[7]);

        if (  0 == val) { return "Infinitesimal"; }
        if (  2 >= val) { return "Microscopic"; }
        if (  4 >= val) { return "Lilliputian"; }
        if (  7 >= val) { return "Minute"; }
        if ( 10 >= val) { return "Minuscule"; }
        if ( 14 >= val) { return "Miniature"; }
        if ( 18 >= val) { return "Teensy"; }
        if ( 23 >= val) { return "Cramped"; }
        if ( 28 >= val) { return "Measly"; }
        if ( 34 >= val) { return "Puny"; }
        if ( 40 >= val) { return "Wee"; }
        if ( 47 >= val) { return "Tiny"; }
        if ( 54 >= val) { return "Baby"; }
        if ( 62 >= val) { return "Confined"; }
        if ( 70 >= val) { return "Undersized"; }
        if ( 79 >= val) { return "Petite"; }
        if ( 88 >= val) { return "Little"; }
        if ( 98 >= val) { return "Cozy"; }
        if (108 >= val) { return "Small"; }

        if (146 >= val) { return "Average-Sized"; }

        if (156 >= val) { return "Good-Sized"; }
        if (166 >= val) { return "Large"; }
        if (175 >= val) { return "Sizable"; }
        if (184 >= val) { return "Big"; }
        if (192 >= val) { return "Oversized"; }
        if (200 >= val) { return "Huge"; }
        if (207 >= val) { return "Extensive"; }
        if (214 >= val) { return "Giant"; }
        if (220 >= val) { return "Enormous"; }
        if (226 >= val) { return "Gigantic"; }
        if (231 >= val) { return "Massive"; }
        if (236 >= val) { return "Immense"; }
        if (240 >= val) { return "Vast"; }
        if (244 >= val) { return "Colossal"; }
        if (247 >= val) { return "Titanic"; }
        if (250 >= val) { return "Humongous"; }
        if (252 >= val) { return "Gargantuan"; }
        if (254 >= val) { return "Monumental"; }

        return "Immeasurable";
    }

    function getDescription(uint256 tokenId) public pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[8]);

        if ( 15 >= val) { return "Sweltering"; }
        if ( 31 >= val) { return "Freezing"; }
        if ( 47 >= val) { return "Dim"; }
        if ( 63 >= val) { return "Bright"; }
        if ( 79 >= val) { return "Barren"; }
        if ( 95 >= val) { return "Plush"; }
        if (111 >= val) { return "Filthy"; }
        if (127 >= val) { return "Dingy"; }
        if (143 >= val) { return "Airy"; }
        if (159 >= val) { return "Stuffy"; }
        if (175 >= val) { return "Rough"; }
        if (191 >= val) { return "Untidy"; }
        if (207 >= val) { return "Dank"; }
        if (223 >= val) { return "Moist"; }
        if (239 >= val) { return "Soulless"; }
        return "Exotic";
    }

    function getExitBiome(
        uint256 tokenId,
        uint256 direction
    ) public pure returns (string memory) {
        require(4 > direction, LootRoomErrors.OUT_OF_RANGE);
        uint8 val = uint8(bytes32(tokenId)[9 + direction]);
        // 9, 10, 11, 12
        return getBiomeName(val);
    }

    function getExitPassable(
        uint256 tokenId,
        uint256 direction
    ) public pure returns (bool) {
        require(4 > direction, LootRoomErrors.OUT_OF_RANGE);
        uint8 val = uint8(bytes32(tokenId)[13 + direction]);
        // 13, 14, 15, 16
        return 128 > val;
    }

    function getLootTokenId(uint256 tokenId) public pure returns (uint256) {
        uint256 lootTokenId = tokenId & 0xFFFF;
        require(0 < lootTokenId && 8001 > lootTokenId, LootRoomErrors.NO_LOOT);
        return lootTokenId;
    }

    function _svgNorth(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked(
            "<text x='250' y='65' font-size='20px'><tspan>",
            getExitBiome(tokenId, 0),
            "</tspan></text>",
            (getExitPassable(tokenId, 0) ?
                "<path d='m250 15 15 26h-30z'/>"
                    : "<rect x='75' y='75' width='350' height='15'/>")

        ));
    }

    function _svgEast(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked(
            "<text transform='rotate(90)' x='250' y='-435'><tspan>",
            getExitBiome(tokenId, 1),
            "</tspan></text>",
            (getExitPassable(tokenId, 1) ?
                "<path d='m483 248-26 15v-30z'/>"
                : "<rect x='410' y='75' width='15' height='350'/>")

        ));
    }

    function _svgSouth(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked(
            "<text transform='scale(-1)' x='-250' y='-435'><tspan>",
            getExitBiome(tokenId, 2),
            "</tspan></text>",
            (getExitPassable(tokenId, 2) ?
                "<path d='m250 481 15-26h-30z'/>"
                : "<rect x='75' y='410' width='350' height='15'/>")
        ));
    }

    function _svgWest(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked(
            "<text transform='rotate(-90)' x='-250' y='65'><tspan>",
            getExitBiome(tokenId, 3),
            "</tspan></text>",
            (getExitPassable(tokenId, 3) ?
                "<path d='m17 248 26 15v-30z'/>"
                : "<rect x='75' y='75' width='15' height='350'/>")
        ));
    }

    function _svgRoom(uint256 tokenId) private pure returns (string memory) {
        return string(abi.encodePacked(
            "<text x='125' y='130' text-align='left' text-anchor='start'><tspan>",
            _article(tokenId),
            "</tspan><tspan x='125' dy='25'>",
            getOpinion(tokenId), "</tspan><tspan x='125' dy='25'>",
            getSize(tokenId), "</tspan><tspan x='125' dy='25'>",
            getDescription(tokenId), "</tspan><tspan x='125' dy='25'>",
            getMaterial(tokenId), "</tspan><tspan x='125' dy='25'>",
            getBiome(tokenId), ".</tspan><tspan x='125' dy='25'>&#160;</tspan>",
            _svgContainer(tokenId, 0),
            _svgContainer(tokenId, 1)

            // I bloody hate the stack...
        ));
    }

    function _svgContainer(
        uint256 tokenId,
        uint256 idx
    ) private pure returns (string memory) {
        string memory container = getContainer(tokenId, idx);
        if (bytes(container).length == 0) {
            return "";
        } else {
            return string(abi.encodePacked(
                "<tspan x='125' dy='25'>", container, "</tspan>\n"
            ));
        }
    }

    function _article(uint256 tokenId) internal pure returns (string memory) {
        uint8 val = uint8(bytes32(tokenId)[6]);
        if (237 >= val) { return "An"; }
        return "A";
    }

    function _image(uint256 tokenId) internal pure returns (string memory) {
        return string(abi.encodePacked(
            "<?xml version='1.0' encoding='UTF-8'?>"
            "<svg version='1.1' viewBox='0 0 500 500' xmlns='http://www.w3.org/2000/svg' style='background:#000'>"
            "<g fill='#fff' font-size='20px' font-family='serif' text-align='center' text-anchor='middle'>",

            // Edge Indicators
            _svgNorth(tokenId),
            _svgEast(tokenId),
            _svgSouth(tokenId),
            _svgWest(tokenId),

            // Room
            _svgRoom(tokenId),

            // I bloody hate the stack...
            _svgContainer(tokenId, 2),
            _svgContainer(tokenId, 3),

            "</text>\n"
            "</g>"
            "</svg>"
        ));
    }
}
