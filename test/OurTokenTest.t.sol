// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "../src/OurToken.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);

        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // bob allows alice to spend 1000 tokens
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    // GPT generated tests
    function testTransfer() public {
        uint256 transferAmount = 50;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransferFromWithoutApproval() public {
        // Attempting a transferFrom without approval should fail
        uint256 transferAmount = 50;

        vm.prank(alice);
        (bool success, ) = address(ourToken).call(
            abi.encodeWithSelector(
                ourToken.transferFrom.selector,
                bob,
                alice,
                transferAmount
            )
        );

        assertTrue(!success, "TransferFrom without approval should fail");
    }

    function testTransferFromWithPartialApproval() public {
        uint256 initialAllowance = 1000;
        uint256 transferAmount = 1500;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        vm.prank(alice);
        (bool success, ) = address(ourToken).call(
            abi.encodeWithSelector(
                ourToken.transferFrom.selector,
                bob,
                alice,
                transferAmount
            )
        );

        assertTrue(
            !success,
            "TransferFrom with insufficient approval should fail"
        );
    }

    function testBurn() public {
        uint256 burnAmount = 25;

        vm.prank(bob);
        ourToken.burn(burnAmount);

        assertEq(ourToken.totalSupply(), STARTING_BALANCE - burnAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - burnAmount);
    }

    function testMint() public {
        uint256 mintAmount = 50;

        vm.prank(bob);
        ourToken.mint(bob, mintAmount);

        assertEq(ourToken.totalSupply(), STARTING_BALANCE + mintAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE + mintAmount);
    }
}
