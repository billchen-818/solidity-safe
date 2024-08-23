// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ERC20PermitDemo} from "../src/ERC20PermitDemo.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol" ;

contract ERC20PermitDemoScript is Script {

    function setUp() public {

    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ERC20PermitDemo erc20PermitDemo = new ERC20PermitDemo("Demo", "Demo");
        console2.log("erc20Permitdemo:", address(erc20PermitDemo));

        vm.stopBroadcast();
    }
}