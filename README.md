# 🎮 Tetris On-Chain (Solidity Edition)

This is a fully on-chain implementation of **Tetris** built with **Solidity**.  
The game logic, board state, and piece movement are all managed by smart contracts — no backend, no off-chain magic.  
Welcome to the world of blockchains... and blocks that *fall*! 🧱

---

## ⚙️ Features

- ⛓️ 100% on-chain gameplay
- 🎲 Randomized `I`-shaped Tetris pieces (expandable)
- ⬅️➡️⬇️ Move controls (left, right, down)
- 🧱 Line clearing and scoring
- 👤 Per-player game state (based on `msg.sender`)
- 🧠 Expandable structure for more pieces, rotations, and logic

---

## 📦 Contract Info

| Feature        | Details                    |
|---------------|----------------------------|
| Language       | Solidity ^0.8.0           |
| Network        | EVM-compatible            |
| Game Field     | 10 x 20 (classic Tetris)  |
| Piece Types    | Only `I` (for now)        |
| Gas Optimized  | Simple, readable code     |

---

## 🚀 Getting Started

### 1. Deploy the contract

Use [Remix](https://remix.ethereum.org), [Foundry](https://book.getfoundry.sh/), or [Hardhat](https://hardhat.org/) to deploy the `OnchainTetris` contract.

### 2. Start a new game

```solidity
tetris.startGame();
