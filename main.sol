// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OnchainTetris {
    uint8 constant WIDTH = 10;
    uint8 constant HEIGHT = 20;

    struct Block {
        uint8 x;
        uint8 y;
    }

    struct Piece {
        Block[4] blocks;
    }

    struct Game {
        bool started;
        uint8[WIDTH][HEIGHT] board;
        Piece currentPiece;
        uint256 score;
    }

    mapping(address => Game) public games;

    modifier gameStarted() {
        require(games[msg.sender].started, "Game not started");
        _;
    }

    function startGame() external {
        Game storage game = games[msg.sender];
        require(!game.started, "Game already started");

        game.started = true;
        game.score = 0;

        spawnNewPiece(game);
    }

    function spawnNewPiece(Game storage game) internal {
        // I-piece vertical at top middle
        game.currentPiece = Piece([
            Block(4, 0),
            Block(4, 1),
            Block(4, 2),
            Block(4, 3)
        ]);
    }

    function moveLeft() external gameStarted {
        Game storage game = games[msg.sender];

        for (uint i = 0; i < 4; i++) {
            if (game.currentPiece.blocks[i].x == 0) return; // hit wall
        }

        for (uint i = 0; i < 4; i++) {
            game.currentPiece.blocks[i].x -= 1;
        }
    }

    function moveRight() external gameStarted {
        Game storage game = games[msg.sender];

        for (uint i = 0; i < 4; i++) {
            if (game.currentPiece.blocks[i].x >= WIDTH - 1) return; // hit wall
        }

        for (uint i = 0; i < 4; i++) {
            game.currentPiece.blocks[i].x += 1;
        }
    }

    function moveDown() external gameStarted {
        Game storage game = games[msg.sender];

        bool canMove = true;
        for (uint i = 0; i < 4; i++) {
            if (game.currentPiece.blocks[i].y >= HEIGHT - 1) {
                canMove = false;
                break;
            }
        }

        if (canMove) {
            for (uint i = 0; i < 4; i++) {
                game.currentPiece.blocks[i].y += 1;
            }
        } else {
            lockPiece(game);
            clearLines(game);
            spawnNewPiece(game);
        }
    }

    function lockPiece(Game storage game) internal {
        for (uint i = 0; i < 4; i++) {
            Block memory b = game.currentPiece.blocks[i];
            if (b.y < HEIGHT && b.x < WIDTH) {
                game.board[b.y][b.x] = 1;
            }
        }
    }

    function clearLines(Game storage game) internal {
        for (uint8 y = 0; y < HEIGHT; y++) {
            bool full = true;
            for (uint8 x = 0; x < WIDTH; x++) {
                if (game.board[y][x] == 0) {
                    full = false;
                    break;
                }
            }

            if (full) {
                // Shift everything above down
                for (uint8 k = y; k > 0; k--) {
                    game.board[k] = game.board[k - 1];
                }
                for (uint8 x = 0; x < WIDTH; x++) {
                    game.board[0][x] = 0;
                }

                game.score += 1;
            }
        }
    }

    function getBoard() external view returns (uint8[WIDTH][HEIGHT] memory) {
        return games[msg.sender].board;
    }

    function getCurrentPiece() external view returns (Block[4] memory) {
        return games[msg.sender].currentPiece.blocks;
    }

    function getScore() external view returns (uint256) {
        return games[msg.sender].score;
    }
}
