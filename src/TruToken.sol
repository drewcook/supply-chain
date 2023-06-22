// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {TruChain} from "./TruChain.sol";

contract TruToken is ERC20 {
    uint256 private constant INITIAL_SUPPLY = 1000000000 * 1e18; // 1,000,000,000 (1 billion)

    mapping(address => TruChain.Participant) public s_participants;

    constructor() ERC20("TruToken", "TRUCH") {
        // Mint initial supply and store in contract
        _mint(address(this), INITIAL_SUPPLY);
    }
}
