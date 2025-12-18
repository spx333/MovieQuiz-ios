//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 18.12.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGamecorrect
        case bestGametotal
        case bestGamedate
        case totalCorrectAnswers
        case totalQuestionAsked
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let bestGamecorrect = storage.integer(forKey: Keys.bestGamecorrect.rawValue)
            let bestGametotal = storage.integer(forKey: Keys.bestGametotal.rawValue)
            let bestGamedate = storage.object(forKey: Keys.bestGamedate.rawValue) as? Date ?? Date()
            return GameResult(correct: bestGamecorrect, total: bestGametotal, date: bestGamedate)
            
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGamecorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGametotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGamedate.rawValue)
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionAsked.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            if (totalQuestionAsked > 0) {
                return Double(totalCorrectAnswers) / Double(totalQuestionAsked) * 100
            }
            else {
                return 0
            }
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionAsked += amount
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
