// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/ERC721.sol";

contract ERC721Test is Test{
    ERC721 erc721;
    address maruti = address(0x1);
    address prapti = address(0x2);
    
    function testMintToken() public {
        erc721 = new ERC721();
        erc721.mint(maruti,0);
        address owner_of = erc721.ownerOf(0);
        assertEq(maruti, owner_of);
    }

    function testTransferToken() public {
        erc721 = new ERC721();
        erc721.mint(maruti,0);

        vm.startPrank(maruti);
        erc721.safeTransferFrom(maruti, prapti, 0);
        address owner_of = erc721.ownerOf(0);
        assertEq(prapti,owner_of);
    }

    function testGetBalance() public {
        erc721 = new ERC721();
        erc721.mint(maruti,0);
        erc721.mint(maruti,1);
        erc721.mint(maruti,2);
        erc721.mint(maruti,3);
        erc721.mint(maruti,4);
        uint256 balance = erc721.balanceOf(maruti);
        assertEq(balance,5);
    }

    function testOnlyOwnerBurn() public {
        erc721 = new ERC721();
        erc721.mint(maruti,0);
        vm.startPrank(maruti);
        erc721.burn(0);
    }
}