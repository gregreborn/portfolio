//
//  Models.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import Foundation

// Models.swift

struct HighScoreResponse: Decodable {
    struct HighScore: Identifiable, Decodable {
        let id = UUID()
        let player: String
        let score: Int

        enum CodingKeys: String, CodingKey {
            case player = "Player"
            case score = "Score"
        }
    }

    let list: [HighScore]?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case list = "List"
        case error = "Error"
    }
}


