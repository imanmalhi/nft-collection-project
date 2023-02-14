const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main() {
  // address of the whitelist contract
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;

  // URL from where we extract the metadata for a NFT
  const metadataURL = METADATA_URL;

  // ContractFactory in ethers.js is an abstraction used to deploy new smart contracts, so nftContract here is a factory for instances of our NFT contract
  const nftContract = await ethers.getContractFactory("nft");

  // deploy the contract
  const deployednftContract = await nftContract.deploy(
    metadataURL,
    whitelistContract
  );

  // wait for contract to finish deploying
  await deployednftContract.deployed();

  // print address of the deployed contract
  console.log("NFT Contract Address: ", deployednftContract.address);
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });