// This line imports the Hardhat Toolbox, which includes ethers, waffle, and other useful plugins
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  // We specify the Solidity compiler version needed for our contracts.
  // 0.8.20 covers all current pragmas (^0.8.x from our contracts and ^0.8.20 from OpenZeppelin).
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true, // Optimizes the contract bytecode for smaller size and lower gas costs
        runs: 200      // Number of times the optimizer will run
      }
    }
  },
  // This section defines different blockchain networks Hardhat can connect to.
  networks: {
    // 'hardhat' is Hardhat's built-in, in-memory development network. Great for quick tests.
    hardhat: {
      // You can add specific configurations here if needed, but defaults are usually fine.
    },
    // 'localhost' points to a local Ethereum node you can start manually (with 'npx hardhat node').
    localhost: {
      url: "http://127.0.0.1:8545", // This is the standard address for a local Hardhat node
    }
  },
  // These are default paths, explicitly defined for clarity.
  paths: {
    sources: "./contracts",   // Your Solidity contract files
    tests: "./test",          // Your JavaScript/TypeScript test files
    cache: "./cache",         // Hardhat's compilation cache
    artifacts: "./artifacts"  // Compiled contract outputs (bytecode, ABI)
  },
  // Optional plugin for reporting gas usage during tests.
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
};