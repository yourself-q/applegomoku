// Board.swift（修正済み）
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

struct AssistInfo {
    let color: Color
    let description: String
}

class Board: ObservableObject {
    static let size = 15
    @Published var stones: [[Stone?]] = Array(repeating: Array(repeating: nil, count: size), count: size)
    @Published var assistInfo: [[AssistInfo?]] = Array(repeating: Array(repeating: nil, count: size), count: size)
    @Published var gameStatus: String = "Game in progress"

    var currentPlayer: Stone.Color = .black // 修正: private -> var

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
            (0, 1), (1, 0), (1, 1), (1, -1)
        ]
        for direction in directions {
            if hasConsecutiveStones(count: 5, from: position, inDirection: direction) {
                highlightWinningLine(at: position, inDirection: direction)
                return true
            }
        }
        return false
    }

    private func highlightWinningLine(at start: (Int, Int), inDirection direction: (Int, Int)) {
        var current = start
        for _ in 0..<5 {
            if isValid(row: current.0, col: current.1) {
                assistInfo[current.0][current.1] = AssistInfo(color: .yellow, description: "Winning line")
            }
            current.0 += direction.0
            current.1 += direction.1
        }
    }

    private func hasConsecutiveStones(count: Int, from start: (Int, Int), inDirection direction: (Int, Int)) -> Bool {
        var current = start
        for _ in 0..<count {
            guard isValid(row: current.0, col: current.1),
                  let stone = stones[current.0][current.1],
                  stone.color == stones[start.0][start.1]?.color else {
                return false
            }
            current.0 += direction.0
            current.1 += direction.1
        }
        return true
    }

    func isValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < Board.size && col >= 0 && col < Board.size
    }
}