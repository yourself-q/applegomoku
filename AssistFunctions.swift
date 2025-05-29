import SwiftUI

extension Board {
    func analyzeBoard() {
        assistInfo = Array(repeating: Array(repeating: nil, count: Board.size), count: Board.size)

        for row in 0..<Board.size {
            for col in 0..<Board.size {
                if stones[row][col] == nil {
                    checkForPatterns(at: (row, col))
                }
            }
        }
    }

    private func checkForPatterns(at position: (Int, Int)) {
        let directions = [(0, 1), (1, 0), (1, 1), (1, -1)]
        for direction in directions {
            checkPattern(in: direction, at: position)
            checkPattern(in: (-direction.0, -direction.1), at: position)
        }
    }

    private func checkPattern(in direction: (Int, Int), at start: (Int, Int)) {
        var current = start
        var pattern = [Stone.Color?]()
        var emptyPositions = [(Int, Int)]()

        while isValid(row: current.0, col: current.1), let stone = stones[current.0][current.1] {
            pattern.append(stone.color)
            current.0 += direction.0
            current.1 += direction.1
        }
        if isValid(row: current.0, col: current.1), stones[current.0][current.1] == nil {
            emptyPositions.append((current.0, current.1))
        }

        current = start
        while isValid(row: current.0, col: current.1), let stone = stones[current.0][current.1] {
            pattern.insert(stone.color, at: 0)
            current.0 -= direction.0
            current.1 -= direction.1
        }
        if isValid(row: current.0, col: current.1), stones[current.0][current.1] == nil {
            emptyPositions.insert((current.0, current.1), at: 0)
        }

        analyzePattern(pattern, emptyPositions: emptyPositions)
    }

    private func analyzePattern(_ pattern: [Stone.Color?], emptyPositions: [(Int, Int)]) {
        guard !pattern.isEmpty else { return }

        let currentPlayerCount = pattern.filter { $0 == currentPlayer }.count
        let opponentCount = pattern.filter { $0 == currentPlayer.opposite }.count

        if currentPlayerCount >= 4 || opponentCount >= 4 {
            for position in emptyPositions {
                assistInfo[position.0][position.1] = AssistInfo(color: .green, description: "Winning move")
            }
            return
        }

        if currentPlayerCount == 3 && opponentCount == 0 {
            if emptyPositions.count >= 2 {
                for position in emptyPositions {
                    assistInfo[position.0][position.1] = AssistInfo(color: .blue, description: "Double Three")
                }
            } else {
                for position in emptyPositions {
                    assistInfo[position.0][position.1] = AssistInfo(color: .blue, description: "Three")
                }
            }
        } else if currentPlayerCount == 2 && opponentCount == 0 {
            for position in emptyPositions {
                assistInfo[position.0][position.1] = AssistInfo(color: .cyan, description: "Two")
            }
        }

        if currentPlayerCount == 2 && opponentCount == 1 && emptyPositions.count >= 2 {
            for position in emptyPositions {
                assistInfo[position.0][position.1] = AssistInfo(color: .blue, description: "Jump Four")
            }
        }
    }
}