import SwiftUI
import Combine

struct Stone {
    enum Color: String {
        case black = "Black"
        case white = "White"

        var opposite: Color {
            self == .black ? .white : .black
        }

        var assistColor: Color {
            self == .black ? .blue : .red
        }
    }

    let color: Color
}

class Board: ObservableObject {
    static let size = 15
    @Published var stones: [[Stone?]] = Array(repeating: Array(repeating: nil, count: size), count: size)
    @Published var assistInfo: [[AssistInfo?]] = Array(repeating: Array(repeating: nil, count: size), count: size)
    @Published var gameStatus: String = "Game in progress"

    private var currentPlayer: Stone.Color = .black

    func reset() {
        stones = Array(repeating: Array(repeating: nil, count: size), count: size)
        assistInfo = Array(repeating: Array(repeating: nil, count: size), count: size)
        gameStatus = "Game in progress"
        currentPlayer = .black
        analyzeBoard()
    }

    func placeStone(at position: (Int, Int), color: Stone.Color) {
        guard stones[position.0][position.1] == nil else { return }

        let stone = Stone(color: color)
        stones[position.0][position.1] = stone

        if checkForWin(at: position) {
            gameStatus = "\(color.rawValue) wins!"
            analyzeBoard()
            return
        }

        currentPlayer = color.opposite
        analyzeBoard()
    }

    private func checkForWin(at position: (Int, Int)) -> Bool {
        let directions = [
            (0, 1), // Horizontal
            (1, 0), // Vertical
            (1, 1), // Diagonal \
            (1, -1) // Diagonal /
        ]

        var winningDirection: (Int, Int)?

        for direction in directions {
            if hasConsecutiveStones(count: 5, from: position, inDirection: direction) {
                winningDirection = direction
            }
        }

        if let direction = winningDirection {
            highlightWinningLine(at: position, inDirection: direction)
            return true
        }

        return false
    }

    private func highlightWinningLine(at start: (Int, Int), inDirection direction: (Int, Int)) {
        var current = start

        for _ in 0..<5 {
            if let stone = stones[current.0][current.1] {
                assistInfo[current.0][current.1] =
                    AssistInfo(color: .yellow,
                              description: "Winning line")
            }

            current.0 += direction.0
            current.1 += direction.1
        }
    }

    private func hasConsecutiveStones(count: Int, from start: (Int, Int), inDirection direction: (Int, Int)) -> Bool {
        var current = start
        var consecutiveCount = 0

        for _ in 0..<count {
            guard let stone = stones[current.0][current.1],
                  stone.color == stones[start.0][start.1]?.color else {
                return false
            }
            consecutiveCount += 1

            current.0 += direction.0
            current.1 += direction.1
        }

        return consecutiveCount == count
    }

    private func updateAssistInfo() {
        assistInfo = Array(repeating: Array(repeating: nil, count: size), count: size)

        for row in 0..<size {
            for col in 0..<size {
                if stones[row][col] == nil {
                    let winPositions = findWinningPositions(for: currentPlayer)
                    if winPositions.contains((row, col)) {
                        assistInfo[row][col] = AssistInfo(color: .green,
                                                          description: "Winning move")
                        continue
                    }

                    let defensivePositions = findWinningPositions(for: currentPlayer.opposite)
                    if defensivePositions.contains((row, col)) {
                        assistInfo[row][col] = AssistInfo(color: .orange,
                                                          description: "Block opponent's win")
                    }
                }
            }
        }
    }

    private func findWinningPositions(for color: Stone.Color) -> Set<(Int, Int)> {
        var winningPositions = Set<(Int, Int)>()

        for row in 0..<size {
            for col in 0..<size {
                if stones[row][col] == nil {
                    stones[row][col] = Stone(color: color)
                    defer { stones[row][col] = nil }

                    if checkForWin(at: (row, col)) {
                        winningPositions.insert((row, col))
                    }
                }
            }
        }

        return winningPositions
    }
}

struct AssistInfo {
    let color: Color
    let description: String
}