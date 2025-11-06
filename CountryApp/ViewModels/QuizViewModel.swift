//
//  QuizViewModel.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import Foundation
import Observation

@Observable
class QuizViewModel {
    var currentQuestion: QuizQuestion?
    var score: Int = 0
    var totalQuestions: Int = 0
    var selectedAnswer: Country?
    var showResult: Bool = false
    var isCorrect: Bool = false
    var gameOver: Bool = false
    
    private let countries: [Country]
    private var usedCountries: Set<String> = []
    private let maxQuestions = 20
    
    init(countries: [Country]) {
        self.countries = countries
    }
    
    func startNewGame() {
        score = 0
        totalQuestions = 0
        usedCountries.removeAll()
        gameOver = false
        generateQuestion()
    }
    
    func generateQuestion() {
        if totalQuestions >= maxQuestions {
            gameOver = true
            return
        }
        
        guard countries.count >= 4 else { return }
        
        let availableCountries = countries.filter { !usedCountries.contains($0.id) }
        
        let countriesPool = availableCountries.count >= 4 ? availableCountries : countries
        
        guard let correctCountry = countriesPool.randomElement() else { return }
        usedCountries.insert(correctCountry.id)
        
        if usedCountries.count >= countries.count {
            usedCountries.removeAll()
            usedCountries.insert(correctCountry.id)
        }
        
        var options = [correctCountry]
        var remainingCountries = countriesPool.filter { $0.id != correctCountry.id }
        
        while options.count < 4 && !remainingCountries.isEmpty {
            if let randomCountry = remainingCountries.randomElement() {
                if !options.contains(where: { $0.flags.png == randomCountry.flags.png }) {
                    options.append(randomCountry)
                }
                remainingCountries.removeAll { $0.id == randomCountry.id }
            }
        }
        
        options.shuffle()
        
        currentQuestion = QuizQuestion(
            correctCountry: correctCountry,
            options: options
        )
        
        selectedAnswer = nil
        showResult = false
        isCorrect = false
    }
    
    func selectAnswer(_ country: Country) {
        guard !showResult else { return }
        
        selectedAnswer = country
        isCorrect = country.id == currentQuestion?.correctCountry.id
        showResult = true
        totalQuestions += 1
        
        if isCorrect {
            score += 1
        }
    }
    
    func nextQuestion() {
        generateQuestion()
    }
}

struct QuizQuestion {
    let correctCountry: Country
    let options: [Country]
}
