//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "only Onwer can call");
        payable(msg.sender).transfer(_amount);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "you are not owner");
        owner = payable(_owner);
    }
}
