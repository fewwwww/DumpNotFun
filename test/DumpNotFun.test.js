const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DumpNotFun", function () {
  let dumpNotFun;
  let layerBank;
  let velodromeRouter;
  let collateralToken;
  let targetToken;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Deploy mocks or actual contracts
    [owner, addr1, addr2] = await ethers.getSigners();

    // Mock LayerBank, VelodromeRouter, CollateralToken, and TargetToken contracts
    const MockToken = await ethers.getContractFactory("ERC20Mock");
    collateralToken = await MockToken.deploy("Collateral Token", "COL", ethers.utils.parseEther("10000"));
    await collateralToken.deployed();

    targetToken = await MockToken.deploy("Target Token", "TAR", ethers.utils.parseEther("10000"));
    await targetToken.deployed();

    const MockLayerBank = await ethers.getContractFactory("MockLayerBank");
    layerBank = await MockLayerBank.deploy();
    await layerBank.deployed();

    const MockVelodromeRouter = await ethers.getContractFactory("MockVelodromeRouter");
    velodromeRouter = await MockVelodromeRouter.deploy();
    await velodromeRouter.deployed();

    // Deploy the DumpNotFun contract
    const DumpNotFun = await ethers.getContractFactory("DumpNotFun");
    dumpNotFun = await DumpNotFun.deploy(layerBank.address, velodromeRouter.address, collateralToken.address, targetToken.address);
    await dumpNotFun.deployed();
  });

  describe("Deployment", function () {
    it("Should set the correct owner", async function () {
      expect(await dumpNotFun.owner()).to.equal(owner.address);
    });
  });

  describe("Open Short Position", function () {
    it("Should open a short position correctly", async function () {
      const collateralAmount = ethers.utils.parseEther("100");
      const borrowAmount = ethers.utils.parseEther("10");

      // Approve and deposit collateral
      await collateralToken.approve(dumpNotFun.address, collateralAmount);
      await dumpNotFun.openShort(collateralAmount, borrowAmount);

      const position = await dumpNotFun.positions(owner.address);
      expect(position.collateralAmount).to.equal(collateralAmount);
      expect(position.borrowedAmount).to.equal(borrowAmount);
    });
  });

  describe("Close Short Position", function () {
    it("Should close a short position correctly", async function () {
      const collateralAmount = ethers.utils.parseEther("100");
      const borrowAmount = ethers.utils.parseEther("10");

      // Open a short position first
      await collateralToken.approve(dumpNotFun.address, collateralAmount);
      await dumpNotFun.openShort(collateralAmount, borrowAmount);

      // Close the short position
      await dumpNotFun.closeShort();

      const position = await dumpNotFun.positions(owner.address);
      expect(position.collateralAmount).to.equal(0);
      expect(position.borrowedAmount).to.equal(0);
    });
  });
});
