// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {TruChain} from "../src/TruChain.sol";

contract TestTruChain is Test {
    TruChain public tc;

    function setUp() public {
        tc = new TruChain();
    }

    function testCounterDefaults() public {
        assertEq(tc.s_productIdCounter(), 0);
        assertEq(tc.s_participantIdCounter(), 0);
        assertEq(tc.s_registrationIdCounter(), 0);
    }
}
