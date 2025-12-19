//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 15.12.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
