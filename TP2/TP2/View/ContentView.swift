import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = HangmanViewModel()
    @State private var showGameView = false
    @State private var showHighScoreView = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your name", text: $viewModel.playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Start Game") {
                    viewModel.startNewGame()
                    showGameView = true
                }
                .disabled(viewModel.playerName.isEmpty)
                .padding()

                Button("High Scores") {
                    showHighScoreView = true
                }
                .padding()

                NavigationLink(destination: HangmanView(viewModel: viewModel), isActive: $showGameView) {
                    EmptyView()
                }

                NavigationLink(destination: HighScoreView(viewModel: viewModel), isActive: $showHighScoreView) {
                    EmptyView()  
                }
            }
            .navigationBarTitle("Welcome to Hangman")
        }
    }
}
