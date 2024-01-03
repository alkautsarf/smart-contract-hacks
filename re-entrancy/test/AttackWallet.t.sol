// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {AttackWallet} from "../src/AttackWallet.sol";
import {Wallet} from "../src/Wallet.sol";
import {Attack} from "../src/Attack.sol";
import {EtherStore} from "../src/EtherStore.sol";

contract TestAttackWallet is Test {
    AttackWallet public attackWallet;
    Wallet public wallet;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");
    address user4 = makeAddr("user4");
    address user5 = makeAddr("user5");

    address[5] public users = [user1, user2, user3, user4, user5];

    address attacker = makeAddr("attacker");

    function setUp() public {
        wallet = new Wallet();
        deal(attacker, 2 ether);

        for (uint256 i = 0; i < 5; i++) {
            deal(users[i], 1 ether);
            vm.prank(users[i]);
            wallet.deposit{value: 0.1 ether}(users[i]);
        }
    }

    function testWalletBalance() public {
        assertEq(address(wallet).balance, 5 ether);
    }

    function testAttackWallet() public {
        // console.log("wallet balance: ", address(wallet).balance);
        vm.startPrank(attacker);
        attackWallet = new AttackWallet(address(wallet));
        // wallet.deposit{value: 1 ether}(address(attackWallet));
        attackWallet.attack{value: 0.1 ether}();
        // assertEq(wallet.balanceOf(address(attackWallet)), 6 ether);
        vm.stopPrank();
        console.log("attack wallet balance: ", address(attackWallet).balance);
        console.log("attacker balance: ", attacker.balance);
    }
}

contract TestAttackEtherStore is Test {
    Attack public attack;
    EtherStore public etherStore;
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    address user3 = makeAddr("user3");
    address user4 = makeAddr("user4");
    address user5 = makeAddr("user5");

    address[5] public users = [user1, user2, user3, user4, user5];

    address attacker = makeAddr("attacker");

    function setUp() public {
        etherStore = new EtherStore();
        deal(attacker, 2 ether);

        for (uint256 i = 0; i < 5; i++) {
            deal(users[i], 1 ether);
            vm.prank(users[i]);
            etherStore.deposit{value: 1 ether}();
        }
    }

    function testEtherStoreBalance() public {
        assertEq(address(etherStore).balance, 5 ether);
    }

    function testAttackEtherStore() public {
        vm.startPrank(attacker);
        attack = new Attack(address(etherStore));
        attack.attack{value: 1 ether}();
        vm.stopPrank();
        assertEq(address(attack).balance, 6 ether);
        console.log("attack wallet balance: ", address(attack).balance);
    }
}
