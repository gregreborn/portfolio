//
//  APIManager.swift
//  TP2
//
//  Created by user238613 on 11/21/23.
//

import Foundation

struct APIManager {

    let baseURL = "https://kubernetes.drynish.synology.me"
    
    func fetchNewWord(completion: @escaping (WordSecret?, Error?) -> Void) {
        let newWordURL = URL(string: "\(baseURL)/new")!
        
        URLSession.shared.dataTask(with: newWordURL) { data, response, error in
            if let error = error {
                print("API request error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("API response data is nil")
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            
            do {
                let wordSecret = try JSONDecoder().decode(WordSecret.self, from: data)
                print("API response word: \(wordSecret.word)")
                print("API response secret: \(wordSecret.secret)")
                completion(wordSecret, nil)
            } catch {
                print("Error decoding API response: \(error.localizedDescription)")
                completion(nil, error)
            }
        }.resume()
    }
    
    func submitScore(word: String, secret: String, player: String, score: Int, completion: @escaping (Error?) -> Void) {
        guard let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let encodedSecret = secret.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode word or secret"]))
            return
        }

        let urlString = "\(baseURL)/solve/\(encodedWord)/\(encodedSecret)/\(player)/\(score)"
        guard let submitScoreURL = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        print("Submitting score to URL: \(submitScoreURL.absoluteString)")

        var request = URLRequest(url: submitScoreURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error submitting score: \(error.localizedDescription)")
                completion(error)
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response from submit score API: \(responseString)")
            } else {
                print("Data encoding failed or data is nil")
            }

            completion(nil)
        }.resume()
    }


    
    func fetchHighScores(forWord word: String, completion: @escaping (HighScoreResponse?, Error?) -> Void) {
        let wordLowercased = word.lowercased()
        
        guard let encodedWord = wordLowercased.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode word"]))
            return
        }

        let highScoresURL = URL(string: "\(baseURL)/score/\(encodedWord)")!

        URLSession.shared.dataTask(with: highScoresURL) { data, response, error in
            if let error = error {
                print("Error fetching high scores: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("High scores data is nil")
                completion(nil, NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Status Code: \(httpResponse.statusCode)")
                if let allHeaderFields = httpResponse.allHeaderFields as? [String: Any] {
                    print("HTTP Response Headers:")
                    for (key, value) in allHeaderFields {
                        print("\(key): \(value)")
                    }
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            do {
                let highScoresResponse = try JSONDecoder().decode(HighScoreResponse.self, from: data)
                completion(highScoresResponse, nil)
            } catch {
                print("Error decoding high scores: \(error)")
                completion(nil, error)
            }
        }.resume()
    }



}

struct WordSecret: Decodable {
    let word: String
    let secret: String

    enum CodingKeys: String, CodingKey {
        case word = "Word"
        case secret = "Secret"
    }
}


