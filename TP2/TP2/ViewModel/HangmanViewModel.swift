//
//  HangmanViewModel.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import Foundation
import SwiftUI
import Combine

class HangmanViewModel: ObservableObject {
    public var game: HangmanGame?
    
    @Published var displayedWord: String
    @Published var triesLeft: Int
    @Published var maxTries: Int = 6
    @Published var guessedLetters: [Character]
    @Published var gameStatus: GameStatus = .ongoing
    @Published var errorMessage: String?
    @Published var highScoreResponse: HighScoreResponse?
    @Published var gameHasEnded = false
    @Published var playerName: String = ""  // Player's name
    @Published var successMessage: String? = nil
    @Published var showHighScores = false
    @Published var topPlayer: String? = nil
    @Published var highScores: [HighScoreResponse.HighScore] = []
    @Published var isSearching = false


    


    
    private var apiManager = APIManager()
    
    enum GameStatus {
        case ongoing, won, lost
    }
    
    init() {
            let placeholderWord = "placeholder"
            let placeholderSecret = "secret"
            self.game = HangmanGame(word: placeholderWord, secret: placeholderSecret)
            
            
            self.displayedWord = game?.displayedWord ?? ""
            self.triesLeft = game?.maxTries ?? 0
            self.guessedLetters = game?.guessedLetters ?? []
            game?.onLose = { [weak self] in
                    self?.handleGameLost()
                }
            }
    
    
    
    func startNewGame() {
        gameHasEnded = false
        showHighScores = false
        errorMessage = nil
        topPlayer = nil
        print("startNewGame() called")

        apiManager.fetchNewWord { [weak self] wordSecret, error in
            DispatchQueue.main.async {
                if let wordSecret = wordSecret {
                    self?.game = HangmanGame(word: wordSecret.word, secret: wordSecret.secret)
                    self?.updatePublishedProperties()
                    self?.fetchHighScores(forWord: wordSecret.word)
                    print("Fetched word from API: \(wordSecret.word)")
                } else if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }


    private func handleGameWon() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.gameStatus = .won
                self.gameHasEnded = true
                self.showHighScores = true
            }
        }

        private func handleGameLost() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.gameStatus = .lost
                self.gameHasEnded = true
            }
        }


    
    func fetchHighScores(forWord word: String) {
           isSearching = true //  true when the search starts
           errorMessage = nil // Reset error message
           apiManager.fetchHighScores(forWord: word) { [weak self] response, error in
               DispatchQueue.main.async {
                   self?.isSearching = false //  false when the search completes
                   if let response = response {
                       self?.highScores = response.list ?? []
                   } else {
                       self?.highScores = [] // Clear highScores if there's an error
                       self?.errorMessage = error?.localizedDescription ?? "No high scores found."
                   }
               }
           }
       }



    
    func clearErrorMessage() {
            errorMessage = nil
        }
    
    func makeGuess(letter: Character) {
        if let game = game {
            game.guess(letter: letter)
            updatePublishedProperties()
            
            if game.checkWinCondition() {
                gameStatus = .won
                self.submitScore(playerName: self.playerName)
                self.handleGameWon()
            } else if game.triesLeft == 0 {
                gameStatus = .lost
                self.handleGameLost()
            }
        }
    }

    private func updatePublishedProperties() {
        if let game = game {
            displayedWord = game.displayedWord
            triesLeft = game.triesLeft
            guessedLetters = game.guessedLetters
        } else {
            // Handle the case where 'game' is nil if needed
        }
    }

    private func submitScore(playerName: String) {
        guard gameStatus == .won, let game = game else { return }

        let score = game.maxTries - game.triesLeft
        apiManager.submitScore(word: game.word, secret: game.secret, player: playerName, score: score) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to submit score: \(error.localizedDescription)"
                } else {
                    self?.successMessage = "Score submitted successfully!"
                }
            }
        }
    }

}
