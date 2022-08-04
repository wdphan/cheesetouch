// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ngmi.sol";

contract MyScript is Script {
    function run() external {
        vm.startBroadcast();

        NGMI ngmi = new NGMI("TEST", "TST", "baseUri");

        vm.stopBroadcast();
    }
}
