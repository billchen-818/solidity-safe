# ERC20-Permit介绍

Permit是在ERC2612中提出来的。

我们先来说一下问题吧，或者每天Permit会有啥问题：
在ERC20的标准中，有两个函数（approve和transferFrom）搭配使用，可以发挥非常强大的功能。具体就是A拥有100个token，A通过调用approve方法可以授权B转移50个token，此时B可以调用transferFrom函数，把A的50个token转移给C。

这里的问题：A调用approve是一笔交易，A提交的一笔交易，需要花费Gas费。

那么，有没有啥方法能达到A授权B的目的，而不让A来出这个Gas费呢？答案是有的就是今天要说的ERC2612，它作为ERC20的扩展，它的内部就是添加一个permit函数，允许用户通过EIP-712签名来修改授权，它带来了以下好处：

- 授权这一步就需要用户在链下签名，减少了一笔交易；
- 可以吧签名数据发送给第三方，由第三方来调用permit函数，这样owner就省了gas；

## 合约

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {IERC20Permit} from "./interfaces/IERC20Permit.sol";

// ERC20PermitDemo 继承了ERC20，EIP712，实现了IERC20Permit接口

contract ERC20PermitDemo is ERC20, IERC20Permit, EIP712 {
    
    mapping(address => uint256) private _nonces;

    bytes32 private constant _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    
    // 构造函数：根据继承顺序来逆序添加构造函数
    constructor(string memory name, string memory symbol) EIP712(name, "1") ERC20(name, symbol) {}

    // permit函数实现
    function permit(
        address owner, // token拥有者
        address spender, // token授权给谁
        uint256 value, // 授权的数量
        uint256 deadline, // 授权的截止时间
        // 签名 v，r, s
        uint8 v, 
        bytes32 r,
        bytes32 s
    ) external virtual override {
        // 确保区块时间小于授权截止时间
        require(block.timestamp < deadline, "ERC20Permit: expired deadline");

        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
        bytes32 hash = _hashTypedDataV4(structHash);

        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");

        // 调用ERC20的内部_approve函数, 实现授权操作
        _approve(owner, spender, value);
    }

    function nonces(address owner) external view virtual override returns(uint256) {
        return _nonces[owner];
    }

    function DOMAIN_SEPARATOR() external view returns (bytes32) {
        return _domainSeparatorV4();
    }

    function _useNonce(address owner) internal virtual returns (uint256 current) {
        current = _nonces[owner];
        _nonces[owner] += 1;
    }
}
```

## 部署

```
forge script script/ERC20PermitDemo.s.sol:ERC20PermitDemoScript --rpc-url $URL_RPC --broadcast
```

生成的合约address: 0x67Ef4943476C8bC64b615eC21ED97aF16Cb41BBb

## 调用

### 编写签名生成js

// TODO: generate js file to signature

### 调用合约permit方法

```
cast send 0x67Ef4943476C8bC64b615eC21ED97aF16Cb41BBb "permit(address,address,uint256,uint256,uint8,bytes32,bytes32)" 0x311D57E555FA26bc66C4d21de68507A605d2EBd1  0x143915dbD26DCBb3D2427656D8CCDC26561Fc58f 100 115792089237316195423570985008687907853269984665640564039457584007913129639935 28 0xfd4803cc4968f4fc38384b2b5a8ee783a23de1a6f07b683179444a8be7375e17 0x5f2a0ebd3c0b2b2c3bfedb86636ead0db4d0fb62f318a68b6770f3f0971390d1 --rpc-url $URL_RPC --private-key $PRIVATE_KEY
```

### 查看授权

```
cast call 0x67Ef4943476C8bC64b615eC21ED97aF16Cb41BBb "allowance(address,address)" 0x311D57E555FA26bc66C4d21de68507A605d2EBd1 0x143915dbD26DCBb3D2427656D8CCDC26561Fc58f --rpc-url $URL_RPC
```