// scripts/deploy.js

const hre = require("hardhat");
require("dotenv").config();

async function main() {
  // Fetch contract factory
  const DumpNotFun = await hre.ethers.getContractFactory("DumpNotFun");

  // Actual addresses on the Mode Network
  const layerBankAddress = "0x0D8F8e271DD3f2fC58e5716d3Ff7041dBe3F0688";  // LayerBank address for USDC lending
  const velodromeRouterAddress = "0x1a05EB736873485655F29a37DEf8a0AA87F5a447";  // Velodrome Router address
  const collateralTokenAddress = "0xA0b86991c6218b36c1d19d4a2e9eb0ce3606eb48";  // USDC token address
  // const targetTokenAddress = "0xYourMemecoinAddress";  // Replace with actual memecoin address

  // Deploy the contract
  const dumpNotFun = await DumpNotFun.deploy(
    layerBankAddress,
    velodromeRouterAddress,
    collateralTokenAddress,
    targetTokenAddress
  );

  await dumpNotFun.deployed();

  console.log("DumpNotFun deployed to:", dumpNotFun.address);
}

// Run the script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
