// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/HelloWorld.sol";

contract HelloWorldTest is Test{
    HelloWorld public helloworld;

    function setUp() public {
        helloworld = new HelloWorld();
    }

    function testGreet() public {
        assertEq(helloworld.greet(), "Hello world!");
    }
}