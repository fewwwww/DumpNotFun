# DumpNotFun

> [!WARNING]  
> DumpNotFun is only an experimental idea.

DumpNotFun is a protocol to short memecoin, inspired by dumpy.fun. This project allows you to short memecoins, introducing a new dimension to memecoin and DeFi.

Just as you can "shill" a memecoin, now you can "shill" that you are shorting a memecoin. Everything is onchain, enabling the potential for short squeezes, adding another exciting layer to the memecoin market dynamic.

## Overview

DumpNotFun is built on the Mode Network, a DeFi-focused EVM OP L2, leveraging the largest lending protocol and decentralized exchange (DEX) available on the network: LayerBank and Velodrome. This implementation provides a new way for users to interact with memecoins by allowing them to profit from both market crashes and the potential for short squeezes.

## Key Features

- Short Memecoins: Bet on the dump of memecoins and profit when their value decreases.
- Onchain Short Squeezes: Since all actions are transparent and on-chain, communities can rally to trigger short squeezes, pumping the price of memecoins.
- Mode Network Integration: Deployed on the Mode Network, benefiting from its DeFi-centric architecture and scalability.
- LayerBank for Lending: Uses LayerBank for secure lending and borrowing.
- Velodrome for Swapping: Velodrome handles all token swaps, ensuring efficient and cost-effective trades.

## How It Works
1) Open a Short Position
2) Deposit collateral in the form of stablecoins (e.g., USDC) into the contract.
3) Borrow memecoins using LayerBank.
4) Swap the borrowed memecoins for stablecoins using Velodrome.
5) Hold the position until the price drops, then close the short for a profit.
6) Close a Short Position
7) Swap stablecoins back into memecoins using Velodrome.
8) Repay the borrowed memecoins to LayerBank.
9) Withdraw your remaining collateral.

## Future Works

- Expanding Lending Markets: In the future, if we can integrate more markets for lending memecoins, DumpNotFun can support a wider range of assets.
- Intent-Based Lending Protocols: Exploring intent-based lending protocols could be key to expanding asset support, as these protocols are designed to support any asset by matching lender and borrower intents efficiently.
