// SPDX-License-Identifier: MIT License

pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    constructor() ERC20("Wrapped Ether", "WETH")  {}

    // 回调函数，当用户往WETH合约转ETH时，会触发deposit()函数
    fallback() external payable {
        deposit();
    }
    // 回调函数，当用户往WETH合约转ETH时，会触发deposit()函数
    receive() external payable {
        deposit();
    }

    // 存款函数，当用户存入ETH时，给他铸造等量的WETH
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    // 提款函数，用户销毁WETH，取回等量的ETH
    function withdraw(uint amount) public {
        require(balanceOf(msg.sender) >= amount);
        _burn(msg.sender, amount);
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }
}