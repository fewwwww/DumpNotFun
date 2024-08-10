require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0",
  networks: {
    mode: {
      url: "https://rpc.mode.network", // Mode Network RPC URL
      accounts: [process.env.PRIVATE_KEY] // Private key of your deployer account
    }
  }
};
