# Gomoku App

This is a SwiftUI implementation of the classic Gomoku game. The app allows two players to play against each other on a 15x15 board, with an assist function that helps detect winning patterns and potential moves.

## Features

- Classic Gomoku gameplay with black and white stones
- Assist function to help detect:
  - Winning moves
  - Four in a row (with one empty space)
  - Jump four (four with a gap)
  - Three in a row
  - Double three
- Highlight effect for winning lines
- Simple animation when placing stones
- Assist ON/OFF toggle

## Files

- `GomokuApp.swift`: Main app entry point
- `ContentView.swift`: Main game view
- `Board.swift`: Game logic and board management
- `AssistFunctions.swift`: Assist function implementation for detecting patterns

## How to Use

1. Open the project in Xcode
2. Run the app on a simulator or physical device
3. Players take turns placing stones by tapping on empty spaces
4. The assist function highlights potential winning moves and other important positions
5. Toggle the assist function on/off using the switch at the top of the screen
6. Reset the game using the "Reset" button

## Implementation Details

The app uses SwiftUI for the user interface and follows a Model-View-ViewModel (MVVM) pattern:

- `Board` class: The model that holds the game state and logic
- `ContentView`: The view that displays the board and handles user interactions
- Assist functions: Methods in the Board class to analyze the board and detect patterns

The assist function analyzes the board each time a stone is placed, looking for various patterns like four in a row, three in a row, etc. It highlights these positions to help players make better decisions.