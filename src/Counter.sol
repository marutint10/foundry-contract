// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter{

    uint private count;

    constructor(uint _count){
        count = _count;
    }

    function incrementCounter() public {
        count += 1;
    }

    function getCount() public view returns(uint){
        return count;
    }
}