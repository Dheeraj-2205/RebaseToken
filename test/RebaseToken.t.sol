// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {RebaseToken} from "../src/RebaseToken.sol";
import {Vault} from "../src/Vault.sol";

import {IRebaseToken} from "../src/interface/IRebaseToken.sol";



contract RebaseTokenTest is Test {

    RebaseToken public rebaseToken;
    Vault public vault;

    address public owner =  makeAddr("owner");
    address public user = makeAddr("user");


    function setUp() public {
        vm.startPrank(owner);
        rebaseToken = new RebaseToken();
        vault = new Vault(IRebaseToken(address(rebaseToken)));
        rebaseToken.grantMintAndBurnRole(address(vault));
        (bool success,) = payable(address(vault)).call{value : 1e18}("");
        vm.stopPrank();
    }

    function testDepositLinear() public {
        
    }
}
