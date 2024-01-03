// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Wallet {
    mapping(address => uint256) public balances;

    function deposit(address _to) public payable {
        balances[_to] = balances[_to] + msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            require(result, "External call returned false");
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}
