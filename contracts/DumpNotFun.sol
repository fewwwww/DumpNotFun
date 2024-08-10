// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@layerbank/contracts/ILayerBank.sol";
import "@velodrome/contracts/interfaces/IVelodromeRouter.sol";

contract DumpNotFun is Ownable, ReentrancyGuard {
    ILayerBank public layerBank;
    IVelodromeRouter public velodromeRouter;
    IERC20 public collateralToken;
    IERC20 public targetToken;

    uint256 public constant COLLATERAL_RATIO = 150; // 150% collateralization ratio

    struct Position {
        uint128 collateralAmount;
        uint128 borrowedAmount;
    }

    mapping(address => Position) public positions;

    event PositionOpened(address indexed user, uint256 collateralAmount, uint256 borrowAmount);
    event PositionClosed(address indexed user, uint256 collateralAmount, uint256 repaidAmount);

    constructor(
        address _layerBank,
        address _velodromeRouter,
        address _collateralToken,
        address _targetToken
    ) {
        layerBank = ILayerBank(_layerBank);
        velodromeRouter = IVelodromeRouter(_velodromeRouter);
        collateralToken = IERC20(_collateralToken);
        targetToken = IERC20(_targetToken);
    }

    function openShort(uint256 collateralAmount, uint256 borrowAmount) external nonReentrant {
        require(collateralAmount * 1e18 / borrowAmount >= COLLATERAL_RATIO * 1e18 / 100, "Insufficient collateral");

        // Transfer collateral from the user to the contract
        require(collateralToken.transferFrom(msg.sender, address(this), collateralAmount), "Collateral transfer failed");

        // Deposit collateral into LayerBank
        collateralToken.approve(address(layerBank), collateralAmount);
        layerBank.deposit(collateralToken, collateralAmount);

        // Borrow the target token
        uint256 borrowResult = layerBank.borrow(targetToken, borrowAmount);
        require(borrowResult == borrowAmount, "Borrowing failed");

        // Swap the borrowed tokens for the collateral token using Velodrome
        uint256 swappedAmount = swapBorrowedForCollateral(borrowAmount);

        // Store the position
        positions[msg.sender] = Position({
            collateralAmount: uint128(collateralAmount),
            borrowedAmount: uint128(borrowAmount)
        });

        // Send the swapped tokens back to the user
        require(collateralToken.transfer(msg.sender, swappedAmount), "Transfer failed");

        emit PositionOpened(msg.sender, collateralAmount, borrowAmount);
    }

    function closeShort() external nonReentrant {
        Position storage position = positions[msg.sender];
        require(position.borrowedAmount > 0, "No open position");

        uint256 currentDebt = position.borrowedAmount;

        // Swap collateral token back to target token using Velodrome
        uint256 swappedAmount = swapCollateralForBorrowed(currentDebt);

        // Repay the debt
        require(targetToken.transferFrom(msg.sender, address(this), swappedAmount), "Repay failed");
        targetToken.approve(address(layerBank), swappedAmount);
        layerBank.repay(targetToken, swappedAmount);

        // Withdraw remaining collateral
        uint256 collateralBalance = position.collateralAmount;
        layerBank.withdraw(collateralToken, collateralBalance);

        // Transfer the remaining collateral back to the user
        require(collateralToken.transfer(msg.sender, collateralBalance), "Collateral withdrawal failed");

        // Clear the position
        delete positions[msg.sender];

        emit PositionClosed(msg.sender, collateralBalance, swappedAmount);
    }

    function swapBorrowedForCollateral(uint256 amount) internal returns (uint256) {
        // Velodrome swap from targetToken to collateralToken
        address;
        path[0] = address(targetToken);
        path[1] = address(collateralToken);

        targetToken.approve(address(velodromeRouter), amount);

        uint256[] memory amounts = velodromeRouter.swapExactTokensForTokens(
            amount,
            0, // Minimum amount out, can be modified based on slippage tolerance
            path,
            address(this),
            block.timestamp
        );

        return amounts[1]; // Return the received amount of collateral tokens
    }

    function swapCollateralForBorrowed(uint256 amount) internal returns (uint256) {
        // Velodrome swap from collateralToken to targetToken
        address;
        path[0] = address(collateralToken);
        path[1] = address(targetToken);

        collateralToken.approve(address(velodromeRouter), amount);

        uint256[] memory amounts = velodromeRouter.swapExactTokensForTokens(
            amount,
            0, // Minimum amount out, can be modified based on slippage tolerance
            path,
            address(this),
            block.timestamp
        );

        return amounts[1]; // Return the received amount of target tokens
    }
}
