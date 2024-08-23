// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {EIP712Example} from "../src/EIP712Example.sol";
import "forge-std/Script.sol";
import "forge-std/console2.sol" ;

contract EIP712ExampleScript is Script {

    function setUp() public {

    }

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        EIP712Example eip712Test = new EIP712Example();
        console2.log("eip712:", address(eip712Test));

        vm.stopBroadcast();
    }
}