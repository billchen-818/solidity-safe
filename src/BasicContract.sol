// SPDX-License-Identifier: MIT License
pragma solidity ^0.8.0;

contract BasicContract {
    // state variables
    address public owner;
    mapping(address => uint256) private balances; 

    // Event
    event Transfer(address sender, address receiver, uint amount);
    // Error define
    error InsufficientBalance();

    constructor() {
        owner = msg.sender;
    }

    fallback() external payable {}

    receive() external payable {}

    modifier onlyOnwer {
        require(msg.sender == owner, "only onwer");
        _;
    }

    function reback(address receiver, uint256 amount) external onlyOnwer {

    }

    function getBalance() external view returns(uint256) {
        return balances[msg.sender];
    }

    function caluApr() public pure returns(uint256) {
        return 0;
    }
}