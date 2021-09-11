// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

import "./LootRoom.sol";
import "@base64-sol/base64.sol";

contract LootRoomRender is LootRoom {
    function tokenURI(uint256 tokenId) external pure returns (string memory) {
        // TODO: Name
        // TODO: Description
        bytes memory json = abi.encodePacked(
            "{\"description\":\"\",\"name\":\"",
            "TODO",
            "\",\"attributes\":[{\"trait_type\":\"Opinion\",\"value\":\"",
            getOpinion(tokenId),
            "\"},{\"trait_type\":\"Size\",\"value\":\"",
            getSize(tokenId),
            "\"},{\"trait_type\":\"Description\",\"value\":\"",
            getDescription(tokenId),
            "\"},{\"trait_type\":\"Material\",\"value\":\"",
            getMaterial(tokenId),
            "\"},{\"trait_type\":\"Biome\",\"value\":\"",
            getBiome(tokenId),
            "\"}],\"image\":\"data:image/svg+xml;base64,",
            Base64.encode(bytes(_image(tokenId))),
            "\"}"
        );

        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(json)
        ));
    }
}
