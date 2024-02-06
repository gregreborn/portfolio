//
//  HangmanGame.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import Foundation

class HangmanGame {
    var word: String = ""
    var secret: String = ""
    
    
    var displayedWord: String {
        didSet {
            if displayedWord == word {
                onWin?()
            }
        }
    }
    
    let maxTries: Int = 6
    var triesLeft: Int = 6
    
    var guessedLetters: [Character] = []
    
    var onWin: (() -> Void)?
    var onLose: (() -> Void)?
    
    init(word: String, secret: String) {
            self.word = word
            self.secret = secret
            self.displayedWord = String(repeating: "_", count: word.count)
        self.onWin = {
                   print("You won")
               }
        }
    
    func guess(letter: Character) {
        let normalizedLetter = String(letter).folding(options: .diacriticInsensitive, locale: .current).lowercased()
        let normalizedWord = word.folding(options: .diacriticInsensitive, locale: .current).lowercased()

        guard !guessedLetters.contains(letter) else { return }
        
        guessedLetters.append(letter)
        
        if normalizedWord.contains(normalizedLetter) {
            revealLetter(letter)
        } else {
            triesLeft -= 1
            if triesLeft <= 0 {
                onLose?()
            }
        }
    }

    
    private func revealLetter(_ letter: Character) {
        let normalizedLetter = String(letter).folding(options: .diacriticInsensitive, locale: .current).lowercased()
        var newDisplayedWord = displayedWord
        
        for (index, wordLetter) in word.enumerated() {
            let normalizedWordLetter = String(wordLetter).folding(options: .diacriticInsensitive, locale: .current).lowercased()
            if normalizedWordLetter == normalizedLetter {
                let startIndex = newDisplayedWord.index(newDisplayedWord.startIndex, offsetBy: index)
                newDisplayedWord.replaceSubrange(startIndex...startIndex, with: String(wordLetter))
            }
        }
        
        displayedWord = newDisplayedWord
        if checkWinCondition() {
            onWin?()
        }
    }

    func checkWinCondition() -> Bool {
        let normalizedDisplayedWord = displayedWord.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        let normalizedWord = word.folding(options: .diacriticInsensitive, locale: .current).lowercased()
        return normalizedDisplayedWord == normalizedWord
    }



    func resetGame(with newWord: String) {
        word = newWord
        displayedWord = String(repeating: "_", count: newWord.count)
        triesLeft = maxTries
        guessedLetters = []
    }
}

