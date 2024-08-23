// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EIP712Example {
    using ECDSA for bytes32;

    bytes32 private constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 private constant UPDATENUMBER_TYPEHASH = keccak256("Balances(address sender,uint256 amount)");
    bytes32 private DOMAIN_SEPARATOR;

    mapping(address => uint256) public balances;
    
    constructor() {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes("EIP712Example")),
            keccak256(bytes("1")),
            block.chainid,
            address(this)
        ));
    }

    function updateNumber(uint256 _num, bytes memory _signature) external {
        require(_signature.length == 65, "invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;

        // 只能用assembly (内联汇编)来从签名中获得r,s,v的值
        assembly {
            /*
            前32 bytes存储签名的长度 (动态数组存储规则)
            add(sig, 32) = sig的指针 + 32
            等效为略过signature的前32 bytes
            mload(p) 载入从内存地址p起始的接下来32 bytes数据
            */
            // 读取长度数据后的32 bytes
            r := mload(add(_signature, 0x20))
            // 读取之后的32 bytes
            s := mload(add(_signature, 0x40))
            // 读取最后一个byte
            v := byte(0, mload(add(_signature, 0x60)))
        }

        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                UPDATENUMBER_TYPEHASH,
                msg.sender,
                _num
            ))
        ));

        address recoveredAddress = digest.recover(v, r, s);
        require(recoveredAddress == msg.sender, "verifyer error");

        balances[msg.sender] += _num;
    }

    function getNumber(address addr) public view returns(uint256) {
        return balances[addr];
    }
}