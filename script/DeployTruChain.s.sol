// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TruChain} from "../src/TruChain.sol";

contract DeployTruChain is Script {
    TruChain private truchain;

    function run() public {
        vm.startBroadcast();
        truchain = new TruChain();
        vm.stopBroadcast();
    }
}
