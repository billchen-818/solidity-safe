// SPDX-License-Identifier: MIT License
pragma solidity ^0.8.0;

import {IERC20} from "./IERC20.sol";

interface IWETH is IERC20 {
    function deposit() external payable;

    function withdraw(uint amount) external;
}