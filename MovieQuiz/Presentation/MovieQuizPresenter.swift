//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Сергей Петров on 15.01.2026.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    
    let questionsAmount: Int = 10
    
    var correctAnswers: Int = 0
    
    var questionFactory: QuestionFactoryProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - QuestionFactoryDelegate

       func didLoadDataFromServer() {
           viewController?.hideLoadingIndicator()
           questionFactory?.requestNextQuestion()
       }

       func didFailToLoadData(with error: Error) {
           viewController?.showNetworkError(message: "Невозможно загрузить данные")
       }
       
       func didReceiveNextQuestion(question: QuizQuestion?) {
           guard let question = question else { return }
           
           currentQuestion = question
           
           let viewModel = convert(model: question)
           
           DispatchQueue.main.async { [weak self] in
               self?.viewController?.show(quiz: viewModel)
           }
       }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
          let text = """
          Ваш результат \(correctAnswers) из \(questionsAmount)
          Количество сыгранных квизов: \(String(describing: statisticService.gamesCount))
          Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)  (\(statisticService.bestGame.date.dateTimeString))
          Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
          """
          
          let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть еще раз!")
          
            viewController?.show(quiz: viewModel)
                  
      } else {
          
          self.switchToNextQuestion()
          
          questionFactory?.requestNextQuestion()
          
          
      }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    
    
}
