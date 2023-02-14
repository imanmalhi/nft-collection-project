// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface nftWhitelist {
    function whitelistAddresses(address) external view returns (bool);
}