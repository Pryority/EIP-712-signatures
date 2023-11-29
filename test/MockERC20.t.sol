// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {SigUtils} from "../src/SigUtils.sol";

contract DepositTest is Test {
    MockERC20 internal token;
    SigUtils internal sigUtils;

    uint256 internal ownerPrivateKey;
    uint256 internal spenderPrivateKey;

    address internal owner;
    address internal spender;

    function setUp() public {
        // Deploy a mock ERC-20 token and SigUtils helper with the token's EIP-712 domain separator
        token = new MockERC20();
        sigUtils = new SigUtils(token.DOMAIN_SEPARATOR());

        // Create private keys to mock the owner and spender
        ownerPrivateKey = 0xA11CE;
        spenderPrivateKey = 0xB0B;

        // Derive owner and spender addresses using the vm.addr cheatcode
        owner = vm.addr(ownerPrivateKey);
        spender = vm.addr(spenderPrivateKey);

        // Mint the owner a test token
        token.mint(owner, 1e18);
    }

    function test_Permit() public {
        // ARRANGE
        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: owner,
            spender: spender,
            value: 1e18,
            nonce: 0,
            deadline: 1 days
        });

        bytes32 digest = sigUtils.getTypedDataHash(permit);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        // ACT
        token.permit(
            permit.owner,
            permit.spender,
            permit.value,
            permit.deadline,
            v,
            r,
            s
        );

        // ASSERT
        assertEq(token.allowance(owner, spender), 1e18);
        assertEq(token.nonces(owner), 1);
    }
}
