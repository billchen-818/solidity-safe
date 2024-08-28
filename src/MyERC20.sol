// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    address private owner;

    constructor() ERC20("MYErc20", "MyERC20") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }


    function mint(address receiver, uint256 amount) external onlyOwner {
        _mint(receiver, amount);
    }
}