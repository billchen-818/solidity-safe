// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {MyERC20} from "../src/MyERC20.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol" ;

contract MyERC20Script is Script {

    function setUp() public {

    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        MyERC20 erc20 = new MyERC20();
        console2.log("erc20:", address(erc20));

        vm.stopBroadcast();
    }
}