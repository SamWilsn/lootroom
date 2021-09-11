// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@base64-sol/base64.sol";
import "./Random.sol";
import "./LootRoom.sol";
import "./Measurable.sol";

library Errors {
    string constant internal OUT_OF_RANGE = "out of range";
    string constant internal NOT_OWNER = "not owner";
    string constant internal ALREADY_CLAIMED = "already claimed";
    string constant internal SOLD_OUT = "sold out";
    string constant internal INSUFFICIENT_VALUE = "not enough";
    string constant internal NONEXISTENT = "nonexistent";
}

contract LootRoomToken is Ownable, Random, ERC721, LootRoom {
    uint256 constant public AUCTION_BLOCKS = 6650;
    uint256 constant public AUCTION_MINIMUM_START = 1 ether;

    IERC721 immutable private LOOT;

    mapping (uint256 => bool) private s_ClaimedBags;

    uint256 private s_StartBlock;
    uint256 private s_StartPrice;
    uint256 private s_Lot;

    constructor(IERC721 loot) ERC721("Loot Room", "ROOM") {
        LOOT = loot;
        _startAuction(0);
    }

    function _generateTokenId() private returns (uint256) {
        return _random() & ~uint256(0xFFFF);
    }

    function _startAuction(uint256 lastPrice) private {
        uint256 oldLot = s_Lot;
        uint256 newLot = oldLot;
        while (newLot == oldLot) {
            // should never need to repeat, but without looping there's a tiny
            // chance the contract gets stuck trying to mint the same token id
            // repeatedly.
            newLot = _generateTokenId();
        }

        s_Lot = newLot;
        s_StartBlock = block.number;
        lastPrice *= 4;
        if (lastPrice < AUCTION_MINIMUM_START) {
            s_StartPrice = AUCTION_MINIMUM_START;
        } else {
            s_StartPrice = lastPrice;
        }
    }

    function getForSale() public view returns (uint256) {
        return s_Lot;
    }

    function getPrice() public view returns (uint256) {
        uint256 currentBlock = block.number - s_StartBlock;
        if (currentBlock >= AUCTION_BLOCKS) {
            return 0;
        } else {
            uint256 startPrice = s_StartPrice;
            uint256 sub = (startPrice * currentBlock) / AUCTION_BLOCKS;
            return startPrice - sub;
        }
    }

    function _buy(uint256 tokenId) private returns (uint256) {
        uint256 lot = s_Lot;
        require(0 == tokenId || tokenId == lot, Errors.SOLD_OUT);

        uint256 price = getPrice();
        require(msg.value >= price, Errors.INSUFFICIENT_VALUE);

        _startAuction(msg.value);

        return lot;
    }

    function safeBuy(uint256 tokenId) external payable returns (uint256) {
        tokenId = _buy(tokenId);
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function buy(uint256 tokenId) external payable returns (uint256) {
        tokenId = _buy(tokenId);
        _mint(msg.sender, tokenId);
        return tokenId;
    }

    function _claim(uint256 lootTokenId) private returns (uint256) {
        require(0 < lootTokenId && 8001 > lootTokenId, Errors.OUT_OF_RANGE);

        require(!s_ClaimedBags[lootTokenId], Errors.ALREADY_CLAIMED);
        s_ClaimedBags[lootTokenId] = true; // Claim before making any calls out.

        require(LOOT.ownerOf(lootTokenId) == msg.sender, Errors.NOT_OWNER);
        return _generateTokenId() | lootTokenId;
    }

    function safeClaim(uint256 lootTokenId) external returns (uint256) {
        uint256 tokenId = _claim(lootTokenId);
        _safeMint(msg.sender, tokenId);
        return tokenId;
    }

    function claim(uint256 lootTokenId) external returns (uint256) {
        uint256 tokenId = _claim(lootTokenId);
        _mint(msg.sender, tokenId);
        return tokenId;
    }

    function tokenName(uint256 tokenId) public pure returns (string memory) {
        uint256 num = uint256(keccak256(abi.encodePacked(tokenId))) & 0xFFFFFF;

        return string(abi.encodePacked(
            roomOpinion(tokenId),
            " ",
            roomType(tokenId),
            " #",
            Strings.toString(num)
        ));
    }

    function tokenDescription(
        uint256 tokenId
    ) public pure returns (string memory) {
        uint256 c;
        c  = bytes(roomContainer(tokenId, 0)).length == 0 ? 0 : 1;
        c += bytes(roomContainer(tokenId, 1)).length == 0 ? 0 : 1;
        c += bytes(roomContainer(tokenId, 2)).length == 0 ? 0 : 1;
        c += bytes(roomContainer(tokenId, 3)).length == 0 ? 0 : 1;

        string memory containers;
        if (0 == c) {
            containers = "";
        } else if (1 == c) {
            containers = "You find one container.";
        } else {
            containers = string(abi.encodePacked(
                "You find ",
                Strings.toString(c),
                " containers."
            ));
        }

        bytes memory exits = abi.encodePacked(
            exitPassable(tokenId, 0) ? string(abi.encodePacked(" To the North, there is a ", exitType(tokenId, 0), ".")) : "",
            exitPassable(tokenId, 1) ? string(abi.encodePacked(" To the East, there is a ", exitType(tokenId, 1), ".")) : "",
            exitPassable(tokenId, 2) ? string(abi.encodePacked(" To the South, there is a ", exitType(tokenId, 2), ".")) : "",
            exitPassable(tokenId, 3) ? string(abi.encodePacked(" To the West, there is a ", exitType(tokenId, 3), ".")) : ""
        );

        return string(abi.encodePacked(
            _article(tokenId),
            " ",
            roomOpinion(tokenId),
            " ",
            roomType(tokenId),
            " with a mostly ",
            roomMaterial(tokenId),
            " construction. Compared to other rooms it is ",
            roomSize(tokenId),
            ", and feels ",
            roomModifier(tokenId),
            ". ",
            containers,
            exits
        ));
    }


    function tokenURI(uint256 tokenId) public override pure returns (string memory) {
        bytes memory json = abi.encodePacked(
            "{\"description\":\"", tokenDescription(tokenId),"\",\"name\":\"",
            tokenName(tokenId),
            "\",\"attributes\":[{\"trait_type\":\"Opinion\",\"value\":\"",
            roomOpinion(tokenId),
            "\"},{\"trait_type\":\"Size\",\"value\":\"",
            roomSize(tokenId)
        );

        bytes memory json2 = abi.encodePacked(
            "\"},{\"trait_type\":\"Description\",\"value\":\"",
            roomModifier(tokenId),
            "\"},{\"trait_type\":\"Material\",\"value\":\"",
            roomMaterial(tokenId),
            "\"},{\"trait_type\":\"Biome\",\"value\":\"",
            roomType(tokenId),
            "\"}],\"image\":\"data:image/svg+xml;base64,",
            Base64.encode(bytes(_image(tokenId))),
            "\"}"
        );

        return string(abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(abi.encodePacked(json, json2))
        ));
    }

    function withdraw(address payable to) external onlyOwner {
        (bool success,) = to.call{value:address(this).balance}("");
        require(success, "could not send");
    }
}
