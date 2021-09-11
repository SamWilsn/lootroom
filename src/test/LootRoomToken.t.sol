// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./utils/LootRoomTokenTest.sol";
import {Errors} from "../LootRoomToken.sol";

contract LootRoomTokenAuction is LootRoomTokenTest {
    function testPriceAtStart() public {
        uint256 initialPrice = lootRoomToken.getPrice();
        assertEq(initialPrice, lootRoomToken.AUCTION_MINIMUM_START());
    }

    function testPriceAfterStart() public {
        hevm.roll(1);
        uint256 initialPrice = lootRoomToken.getPrice();
        assertLt(initialPrice, lootRoomToken.AUCTION_MINIMUM_START());
    }

    function testPriceBeforeEnd() public {
        hevm.roll(lootRoomToken.AUCTION_BLOCKS() - 1);
        uint256 initialPrice = lootRoomToken.getPrice();
        assertGt(initialPrice, 0);
    }

    function testPriceAtEnd() public {
        hevm.roll(lootRoomToken.AUCTION_BLOCKS());
        uint256 initialPrice = lootRoomToken.getPrice();
        assertEq(initialPrice, 0);
    }

    function testPriceAtMaxBlock() public {
        hevm.roll(type(uint256).max);
        uint256 initialPrice = lootRoomToken.getPrice();
        assertEq(initialPrice, 0);
    }

    function testSafeBuyInvalid() public {
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();

        uint256 initialLot = lootRoomToken.getForSale();
        try lootRoomToken.safeBuy{value: value}(initialLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(
                error,
                "ERC721: transfer to non ERC721Receiver implementer"
            );
        }
    }

    function testBuyExactUnchanged() public {
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();

        uint256 initialLot = lootRoomToken.getForSale();
        uint256 purchasedLot = lootRoomToken.buy{value: value}(initialLot);
        assertEq(initialLot, purchasedLot);

        try lootRoomToken.lootId(purchasedLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, LootRoomErrors.NO_LOOT);
        }

        address owner = lootRoomToken.ownerOf(purchasedLot);
        assertEq(owner, address(this));
    }

    function testBuyExactChanged() public {
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();

        uint256 initialLot = lootRoomToken.getForSale();
        lootRoomToken.buy{value: value}(0);

        try lootRoomToken.buy{value: value * 4}(initialLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.SOLD_OUT);
        }
    }

    function testBuyAnyUnchanged() public {
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();

        uint256 initialLot = lootRoomToken.getForSale();
        uint256 purchasedLot = lootRoomToken.buy{value: value}(0);
        assertEq(initialLot, purchasedLot);

        try lootRoomToken.lootId(purchasedLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, LootRoomErrors.NO_LOOT);
        }

        address owner = lootRoomToken.ownerOf(purchasedLot);
        assertEq(owner, address(this));
    }

    function testBuyAnyChanged() public {
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();

        uint256 initialLot = lootRoomToken.getForSale();
        lootRoomToken.buy{value: value}(0);

        uint256 purchasedLot = lootRoomToken.buy{value: value * 4}(0);
        assertTrue(initialLot != purchasedLot);

        try lootRoomToken.lootId(purchasedLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, LootRoomErrors.NO_LOOT);
        }

        address owner = lootRoomToken.ownerOf(purchasedLot);
        assertEq(owner, address(this));
    }

    function testBuyAnyFarFuture() public {
        hevm.roll(type(uint256).max - 1);

        uint256 initialLot = lootRoomToken.getForSale();
        uint256 purchasedLot = lootRoomToken.buy{value: 0}(0);
        assertEq(initialLot, purchasedLot);

        try lootRoomToken.lootId(purchasedLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, LootRoomErrors.NO_LOOT);
        }

        address owner = lootRoomToken.ownerOf(purchasedLot);
        assertEq(owner, address(this));
    }

    function testBuyExactHalfway() public {
        hevm.roll(lootRoomToken.AUCTION_BLOCKS() / 2);

        uint256 value = lootRoomToken.AUCTION_MINIMUM_START() / 2;

        uint256 initialLot = lootRoomToken.getForSale();

        // Try buying with insufficient funds.
        try lootRoomToken.buy{value: value - 1}(initialLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.INSUFFICIENT_VALUE);
        }

        // Buy with exactly enough funds.
        uint256 purchasedLot = lootRoomToken.buy{value: value}(initialLot);
        assertEq(initialLot, purchasedLot);

        try lootRoomToken.lootId(purchasedLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, LootRoomErrors.NO_LOOT);
        }

        address owner = lootRoomToken.ownerOf(purchasedLot);
        assertEq(owner, address(this));

        // Check the purchase price after.
        assertEq(lootRoomToken.getPrice(), value * 4);
    }
}

contract LootRoomTokenClaim is LootRoomTokenTest {
    function testClaimThenBuy() public {
        uint256 initialLot = lootRoomToken.getForSale();
        uint256 tokenId = lootRoomToken.claim(myBag);
        assertTrue(initialLot != tokenId);

        assertEq(lootRoomToken.lootId(tokenId), 1);
        assertEq(lootRoomToken.ownerOf(tokenId), address(this));

        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();
        uint256 purchasedLot = lootRoomToken.buy{value: value}(initialLot);
        assertEq(initialLot, purchasedLot);
    }

    function testClaimOwn() public {
        uint256 tokenId = lootRoomToken.claim(myBag);
        assertEq(lootRoomToken.lootId(tokenId), 1);
        assertEq(lootRoomToken.ownerOf(tokenId), address(this));
    }

    function testClaimOthers() public {
        try lootRoomToken.claim(otherBag) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.NOT_OWNER);
        }
    }

    function testClaimTwice() public {
        lootRoomToken.claim(myBag);

        try lootRoomToken.claim(myBag) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.ALREADY_CLAIMED);
        }
    }
}

contract LootRoomTokenBuyReentrant is LootRoomTokenTest, IERC721Receiver {
    bool received;
    uint256 initialLot;

    function testSafeBuyReentrant() public {
        initialLot = lootRoomToken.getForSale();
        received = false;
        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();
        lootRoomToken.safeBuy{value: value}(0);
        assertTrue(received);
        assertEq(lootRoomToken.ownerOf(initialLot), address(this));
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override returns (bytes4) {
        uint256 value = lootRoomToken.getPrice();

        // Verify that rebuying the same token fails.
        try lootRoomToken.buy{value: value}(initialLot) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.SOLD_OUT);
        }

        // Verify that buying a different token works.
        uint256 bought = lootRoomToken.buy{value: value}(0);
        assertEq(lootRoomToken.ownerOf(bought), address(this));

        received = true;
        return IERC721Receiver.onERC721Received.selector;
    }
}

contract LootRoomTokenClaimReentrant is LootRoomTokenTest, IERC721Receiver {
    bool received;

    function testSafeClaimReentrant() public {
        received = false;
        lootRoomToken.safeClaim(myBag);
        assertTrue(received);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external override returns (bytes4) {
        try lootRoomToken.claim(myBag) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, Errors.ALREADY_CLAIMED);
            received = true;
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}

contract LootRoomTokenWithdraw is LootRoomTokenTest {
    receive() external payable {}

    function testWithdrawAsOwner() public {
        uint256 initialBalance = address(this).balance;

        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();
        lootRoomToken.buy{value: value}(0);
        assertEq(address(lootRoomToken).balance, value);
        assertLt(address(this).balance, initialBalance);

        lootRoomToken.withdraw(payable(this));

        assertEq(address(this).balance, initialBalance);
    }

    function testWithdrawNonOwner() public {
        lootRoomToken.renounceOwnership();

        uint256 value = lootRoomToken.AUCTION_MINIMUM_START();
        lootRoomToken.buy{value: value}(0);
        assertEq(address(lootRoomToken).balance, value);

        try lootRoomToken.withdraw(payable(this)) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Ownable: caller is not the owner");
        }
    }
}
