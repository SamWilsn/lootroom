// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.6;

contract Measurable {
    event Measurement(
        string name,
        uint256 gas
    );

    constructor() {
        uint256 chainId;
        assembly {
            chainId := chainid()
        }
        require(1 != chainId);
    }

    modifier measured(string memory name) {
        uint256 before = gasleft();
        _;
        emit Measurement(name, before - gasleft());
    }
}
