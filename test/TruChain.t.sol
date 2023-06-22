// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TruChain} from "../src/TruChain.sol";

contract TestTruChain is Test {
    TruChain public tc;

    function setUp() public {
        tc = new TruChain();
    }
}
