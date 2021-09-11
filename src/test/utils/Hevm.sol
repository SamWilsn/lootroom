// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

abstract contract Hevm {
    // sets the block timestamp to x
    function warp(uint x) public virtual;
    // sets the block number to x
    function roll(uint x) public virtual;
    // sets the slot loc of contract c to val
    function store(address c, bytes32 loc, bytes32 val) public virtual;
    function ffi(string[] calldata) external virtual returns (bytes memory);
}
