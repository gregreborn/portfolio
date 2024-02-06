//
//  HangmanView.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import SwiftUI


struct HangmanView: View {
    @ObservedObject var viewModel: HangmanViewModel
    @State private var showHighScoreView = false 

    let buttonWidth = (UIScreen.main.bounds.width - 120) / 7

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Hangman")
                    .font(.headline)
                    .padding()
                Text("Best guess by: \(viewModel.topPlayer ?? "fetching...")")
                    .font(.subheadline)
                    .padding()



                Text(viewModel.displayedWord)
                    .font(.title)
                    .kerning(2)
                    .padding()

                Image("stage-\(viewModel.maxTries - viewModel.triesLeft)")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(maxWidth: .infinity)

                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: buttonWidth, maximum: buttonWidth)), count: 7), spacing: 20) {
                        ForEach(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ"), id: \.self) { letter in
                            LetterButtonView(letter: String(letter), action: {
                                viewModel.makeGuess(letter: letter)
                            })
                            .frame(width: buttonWidth, height: buttonWidth)
                        }
                    }
                    .padding(.horizontal)
                }

                .alert(isPresented: $viewModel.gameHasEnded) {
                    Alert(
                        title: Text(viewModel.gameStatus == .won ? "Congratulations" : "Game Over"),
                        message: Text(viewModel.gameStatus == .won ? "You guessed the word!" : "Try again!"),
                        dismissButton: .default(Text("High Scores"), action: {
                            showHighScoreView = true
                        })
                    )
                }

                NavigationLink(destination: HighScoreView(viewModel: viewModel), isActive: $showHighScoreView) {
                    EmptyView()
                }
            }
            .navigationBarTitle("Hangman", displayMode: .inline)
            .padding()
        }
    }
}








