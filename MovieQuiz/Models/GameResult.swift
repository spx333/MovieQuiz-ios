//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 18.12.2025.
//

import Foundation

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ other: GameResult) -> Bool {
        return correct > other.correct
    }
}
