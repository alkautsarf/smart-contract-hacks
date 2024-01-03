// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Wallet} from "../src/Wallet.sol";
import {AttackWallet} from "../src/AttackWallet.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract DeployWallet is Script {
    function run() public {
        vm.startBroadcast();
        Wallet wallet = new Wallet();
        wallet.deposit{value: 0.1 ether}(msg.sender);
        vm.stopBroadcast();
    }
}

contract DeployAttackWallet is Script {
    function run() public {
        address targetedContract = DevOpsTools.get_most_recent_deployment("Wallet", block.chainid);
        vm.startBroadcast();
        AttackWallet attackWallet = new AttackWallet(targetedContract);
        attackWallet.attack{value: 0.1 ether}();
        vm.stopBroadcast();
    }
}