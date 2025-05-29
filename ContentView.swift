// ContentView.swift（修正済み）
import SwiftUI

struct ContentView: View {
    @StateObject private var board = Board()
    @State private var selectedColor: Stone.Color = .black
    @State private var assistEnabled = true

    var body: some View {
        VStack {
            HStack {
                Toggle("Assist", isOn: $assistEnabled)
                    .padding()

                Spacer()

                Button(action: {
                    board.reset()
                }) {
                    Text("Reset")
                        .padding()
                }
            }

            Grid(Board.size) { row, col in
                let stone = board.stones[row][col]

                ZStack {
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 40, height: 40)

                    if let stoneColor = stone?.color {
                        Circle()
                            .fill(stoneColor == .black ? Color.black : Color.white)
                            .shadow(radius: 2)
                            .frame(width: 36, height: 36)
                            .opacity(stoneColor == .black ? 1.0 : 0.8)
                            .scaleEffect(1.1)
                            .animation(.easeIn(duration: 0.2), value: stone)
                    }

                    if assistEnabled, let assistInfo = board.assistInfo[row][col] {
                        Circle()
                            .stroke(assistInfo.color, lineWidth: 2)
                            .opacity(assistInfo.description == "Winning line" ? 1.0 : 0.6)
                            .frame(width: 42, height: 42)
                            .animation(
                                .easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true),
                                value: assistInfo.description
                            )
                    }
                }
                .onTapGesture {
                    if stone == nil {
                        withAnimation {
                            board.placeStone(at: (row, col), color: selectedColor)
                            selectedColor = selectedColor == .black ? .white : .black
                        }
                    }
                }
            }
            .frame(width: 600, height: 600)

            Text(board.gameStatus)
                .font(.headline)
                .padding()
        }
        .onAppear {
            board.analyzeBoard()
        }
    }
}

struct Grid<Content: View>: View {
    let size: Int
    let content: (Int, Int) -> Content

    init(_ size: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.size = size
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<size, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<size, id: \.self) { col in
                        content(row, col)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
