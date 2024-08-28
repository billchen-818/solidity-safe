# 基础知识总结

基础合约

```
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
```

上面是一个solidity的基础合约，从基础合约来总结solidity的基础知识点：

- 1、合约如何定义？
- 2、从合约定义引出合约可以继承合约，可以继承接口？
- 3、状态变量以及访问修饰符有哪些及其区别？
- 4、事件的定义？
- 5、错误的定义？
- 6、构造函数的定义以及有继承时构造函数如何编写？
- 7、fallback函数和receive函数是啥，有啥区别？
- 8、函数修饰符modifier是啥？
- 9、函数定义？
- 10、view函数与pure函数？
- 11、函数访问修饰符有哪些及其区别？
- 12、合约中可以使用的常量有哪些？（msg.sender）