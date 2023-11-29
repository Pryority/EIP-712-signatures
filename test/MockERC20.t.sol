// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Test, console2} from "forge-std/Test.sol";
import {MockERC20} from "../src/MockERC20.sol";
import {SigUtils} from "../src/SigUtils.sol";

// test
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
        sigUtils = new SigUtils(token.DOMAIN_SEPARATOR);

        // Create private keys to mock the owner and spender
        ownerPrivateKey = 0xA11CE;
        spenderPrivateKey = 0xB0B;

        // Derive owner and spender addresses using the vm.addr cheatcode
        owner = vm.addr(ownerPrivateKey);
        spender = vm.addr(spenderPrivateKey);

        // Mint the owner a test token
        token.mint(owner, 1e18);
    }
}
