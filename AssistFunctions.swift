import SwiftUI

extension Board {
    func analyzeBoard() {
        assistInfo = Array(repeating: Array(repeating: nil, count: size), count: size)

        for row in 0..<size {
            for col in 0..<size {
                if stones[row][col] == nil {
                    checkForPatterns(at: (row, col))
                }
            }
        }
    }

    private func checkForPatterns(at position: (Int, Int)) {
        let directions = [
            (0, 1), // Horizontal
            (1, 0), // Vertical
            (1, 1), // Diagonal \
            (1, -1) // Diagonal /
        ]

        for direction in directions {
            checkPattern(in: direction, at: position)
            checkPattern(in: (-direction.0, -direction.1), at: position)
        }
    }

    private func checkPattern(in direction: (Int, Int), at start: (Int, Int)) {
        var current = start
        var pattern = [Stone.Color?]()
        var emptyPositions = [(Int, Int)]()

        // Look in the positive direction first
        while let stone = stones[current.0][current.1] {
            pattern.append(stone.color)
            current.0 += direction.0
            current.1 += direction.1
        }
        if stones[current.0][current.1] == nil {
            emptyPositions.append((current.0, current.1))
        }

        // Look in the negative direction
        current = start
        while let stone = stones[current.0][current.1] {
            pattern.insert(stone.color, at: 0)
            current.0 -= direction.0
            current.1 -= direction.1
        }
        if stones[current.0][current.1] == nil {
            emptyPositions.insert((current.0, current.1), at: 0)
        }

        // Analyze the pattern
        analyzePattern(pattern, emptyPositions: emptyPositions)
    }

    private func analyzePattern(_ pattern: [Stone.Color?], emptyPositions: [(Int, Int)]) {
        guard !pattern.isEmpty else { return }

        let currentPlayerCount = pattern.filter { $0 == currentPlayer }.count
        let opponentCount = pattern.filter { $0 == currentPlayer.opposite }.count

        if currentPlayerCount >= 4 || opponentCount >= 4 {
            // Winning or blocking move
            for position in emptyPositions {
                assistInfo[position.0][position.1] =
                    AssistInfo(color: .green,
                              description: "Winning move")
            }
            return
        }

        if currentPlayerCount == 3 && opponentCount == 0 {
            // Three in a row
            for position in emptyPositions {
                assistInfo[position.0][position.1] =
                    AssistInfo(color: Color.blue,
                              description: "Three")
            }
        } else if currentPlayerCount == 2 && opponentCount == 0 {
            // Two in a row
            for position in emptyPositions {
                assistInfo[position.0][position.1] =
                    AssistInfo(color: Color.cyan,
                              description: "Two")
            }
        }

        // Check for jump fours and other complex patterns
        if currentPlayerCount == 2 && opponentCount == 1 && emptyPositions.count >= 2 {
            for position in emptyPositions {
                assistInfo[position.0][position.1] =
                    AssistInfo(color: Color.blue,
                              description: "Jump Four")
            }
        }

        // Check for double threes
        if currentPlayerCount == 3 && opponentCount == 0 && emptyPositions.count >= 2 {
            for position in emptyPositions {
                assistInfo[position.0][position.1] =
                    AssistInfo(color: Color.blue,
                              description: "Double Three")
            }
        }
    }
}