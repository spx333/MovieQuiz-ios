//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 18.12.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Constants
    
    private enum Keys: String {
        case gamesCount
        case bestGamecorrect
        case bestGametotal
        case bestGamedate
        case totalCorrectAnswers
        case totalQuestionAsked
    }
    
    // MARK: - Dependencies
    
    private let storage: UserDefaults = .standard
    
    // MARK: - StatisticServiceProtocol (Public API)
    
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
    
    // MARK: - Public Methods
    
    func store(correct count: Int, total amount: Int) {
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionAsked += amount
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    // MARK: - Private Properties
    
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
}
