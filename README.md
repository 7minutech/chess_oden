# Chess Game

A command line-based Chess game where two players can play against each other. The game ensures that players can only make legal moves and correctly declares "check" and "checkmate" situations. It also allows you to save and load the game state at any time.

## Features

- Play chess against another person in the terminal.
- Properly enforce the rules of chess, including illegal move prevention and check/checkmate detection.
- Save and load game progress.
- Modular and clean class structure with methods doing only one thing each.
- Unit tests using RSpec to ensure reliability.

## Getting Started

To run the game, follow these steps:

### Prerequisites

Make sure you have the following installed:

- **Ruby** (version 2.7+)
- **Bundler** (for managing gems)

### Installing Dependencies

First, run the following command to install the required dependencies:

```bash
bundle install
```

This will install all the gems listed in the `Gemfile.lock`, including:

- `rainbow` (for color support)
- `pry-byebug` (for debugging)
- `rspec` (for testing)
- `rubocop` (for code linting)
- `ruby-progressbar` (for progress bars)
- `unicode-display_width` (for better Unicode support)

Alternatively, if you're not using Bundler, you can install the gems manually using:

```bash
gem install rainbow pry-byebug rspec rubocop ruby-progressbar unicode-display_width
```

### Running the Game

Once you’ve installed the necessary dependencies, you can start the game by following these steps:

1. **Clone the repository**:
   Clone this repository to your local machine:

   ```bash
   git git@github.com:7minutech/chess_oden.git
   cd chess_oden
   ```

2. **Run the Game**:
   The game works best in **Git Bash**, **VSCode terminal**, or another terminal that supports Unicode characters and color. To start the game, run the following command in the terminal:

   ```bash
   ruby main.rb
   ```

   This will start the chess game in your terminal. Follow the prompts to play the game.

## Playing the Game

Once the game starts, you can play by choosing pieces and moving them around the board. Here's how:

1. **Pick the piece you want to move**:
   - The game will display the board in the terminal.
   - Each square on the board is represented by its coordinate (e.g., `a1`, `e2`, `h8`).
   - To select a piece to move, type the **coordinate** of the square containing the piece you want to move (e.g., `e2` for a pawn or `g1` for a knight).

2. **Choose where to move it**:
   - After selecting the piece, type the **coordinate** of the square where you'd like to move it (e.g., `e4` to move a pawn from `e2` to `e4`).

3. **Validating the Move**:
   - The game will check if the move is valid according to chess rules.
   - If the move is illegal, the game will prompt you to select a valid move.

4. **Switching Turns**:
   - The game alternates turns between the two players after each valid move. Player 1 (White) always starts.

5. **Ending the Game**:
   - The game will end when one player is in "checkmate" or if a stalemate occurs. The result will be displayed in the terminal.

### Terminal Recommendations

- **Recommended Terminal**: The game works best in the **VSCode terminal**. This terminal supports both Unicode characters (like the chess pieces) and color output correctly.
  
- **Note**: You may experience issues with color output or Unicode characters in **Windows PowerShell** or **Command Prompt**. For the best experience, use **VSCode terminal**.
  
### Saving and Loading the Game

- You can save and load the game state at any time during your session. Ensure that you follow the instructions in the game’s commands.
