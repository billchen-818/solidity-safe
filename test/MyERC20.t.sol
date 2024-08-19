// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MyERC20} from "../src/MyERC20.sol";

contract MyERC20Test is Test {
    MyERC20 public erc20;

    function setUp() public {
        erc20 = new MyERC20();
    }

    function test_Name() public view {
        assertEq(erc20.name(), "MYErc20");
    }
}