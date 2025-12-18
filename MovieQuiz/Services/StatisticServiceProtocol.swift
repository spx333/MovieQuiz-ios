//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 18.12.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
