import SwiftUI

struct HighScoreView: View {
    @ObservedObject var viewModel: HangmanViewModel
    @State private var searchWord = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            HStack {
                TextField("Rechercher un mot", text: $searchWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if viewModel.isSearching { 
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button("Search") {
                        viewModel.fetchHighScores(forWord: searchWord)
                    }
                }
            }
            .padding()

            if viewModel.highScores.isEmpty && !viewModel.isSearching && viewModel.errorMessage == nil {
                Text("No high scores to display.")
                    .foregroundColor(.secondary)
            } else if !viewModel.highScores.isEmpty {
                List(viewModel.highScores) { highScore in
                    HStack {
                        Text(highScore.player)
                        Spacer()
                        Text("\(highScore.score)")
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitle("High Scores", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}
