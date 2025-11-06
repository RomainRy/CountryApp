//
//  QuizView.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct QuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: QuizViewModel
    
    init(countries: [Country]) {
        _viewModel = State(initialValue: QuizViewModel(countries: countries))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header avec score
            HStack {
                Text("Question: \(viewModel.totalQuestions)/\("20")")
                    .font(.headline)
                Spacer()
                Button("Quitter") {
                    dismiss()
                }
            }
            .padding()
            Spacer()
            
            if viewModel.gameOver {
                VStack(spacing: 20) {
                    Spacer()
                    Text("Quiz terminé !")
                        .font(.largeTitle)
                        .bold()
                    
                    Image(resultImageName(for: viewModel.score))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: viewModel.score)
                    
                    Text("Score final: \(viewModel.score)/\(viewModel.totalQuestions)")
                        .font(.title2)
                    
                    PrimaryButton(
                        title: "Recommencer",
                        style: .primary,
                        action: {
                            viewModel.startNewGame()
                        }
                        
                    )
                    .padding()
                    Spacer()
                }
            } else if let question = viewModel.currentQuestion {
                VStack(spacing: 30) {
                    Text("Quel est le drapeau de :")
                        .font(.title3)
                    Text(question.correctCountry.displayName)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(question.options) { country in
                            FlagOptionButton(
                                country: country,
                                isSelected: viewModel.selectedAnswer?.id == country.id,
                                isCorrect: viewModel.showResult && country.id == question.correctCountry.id,
                                isIncorrect: viewModel.showResult && viewModel.selectedAnswer?.id == country.id && !viewModel.isCorrect,
                                showResult: viewModel.showResult
                            ) {
                                viewModel.selectAnswer(country)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    
                    if viewModel.showResult {
                        VStack(spacing: 15) {
                            Image(viewModel.isCorrect ? "correct" : "croix")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(), value: viewModel.isCorrect)
                            
                            Text(viewModel.isCorrect ? "Bonne réponse !" : "Mauvaise réponse")
                                .font(.title2)
                                .bold()
                                .foregroundColor(viewModel.isCorrect ? .green : .red)
                            
                            if let selected = viewModel.selectedAnswer, !viewModel.isCorrect {
                                Text("Tu as cliqué sur \(selected.displayName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            PrimaryButton(
                                title: "Question suivante",
                                style: .primary,
                                action: {
                                    viewModel.nextQuestion()
                                }
                            )
                        }
                        .padding()
                        Spacer()
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    Image(.globeTerrestre)
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                    Text("Quiz des drapeaux")
                        .font(.largeTitle)
                        .bold()
                    Text("Trouve le drapeau correspondant au pays !")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    PrimaryButton(
                        title: "Commencer",
                        style: .primary,
                        action: {
                            viewModel.startNewGame()
                        }
                    )
                    .padding()
                    Spacer()
                }
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func resultImageName(for score: Int) -> String {
        switch score {
        case 0..<10:
            return "failure"
        case 10..<15:
            return "medaille"
        default:
            return "succes"
        }
    }
}

struct FlagOptionButton: View {
    let country: Country
    let isSelected: Bool
    let isCorrect: Bool
    let isIncorrect: Bool
    let showResult: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            AsyncImage(url: URL(string: country.flags.png)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected || showResult ? 4 : 2)
            )
            .shadow(color: shadowColor, radius: isSelected ? 8 : 4)
        }
        .disabled(showResult)
        .animation(.spring(response: 0.3), value: isSelected)
        .animation(.spring(response: 0.3), value: showResult)
    }
    
    private var borderColor: Color {
        if showResult {
            if isCorrect {
                return .green
            } else if isIncorrect {
                return .red
            }
        }
        return isSelected ? .blue : .gray.opacity(0.3)
    }
    
    private var shadowColor: Color {
        if showResult {
            if isCorrect {
                return .green.opacity(0.5)
            } else if isIncorrect {
                return .red.opacity(0.5)
            }
        }
        return isSelected ? .blue.opacity(0.3) : .clear
    }
}

#Preview {
    let mockCountries = [
        Country(
            name: Country.Name(common: "France"),
            translations: Country.Translations(fra: Country.Translations.Translation(common: "France")),
            capital: ["Paris"],
            population: 67000000,
            flags: Country.Flags(png: "https://flagcdn.com/w320/fr.png"),
            area: 551695
        ),
        Country(
            name: Country.Name(common: "Germany"),
            translations: Country.Translations(fra: Country.Translations.Translation(common: "Allemagne")),
            capital: ["Berlin"],
            population: 83000000,
            flags: Country.Flags(png: "https://flagcdn.com/w320/de.png"),
            area: 357022
        ),
        Country(
            name: Country.Name(common: "Italy"),
            translations: Country.Translations(fra: Country.Translations.Translation(common: "Italie")),
            capital: ["Rome"],
            population: 60000000,
            flags: Country.Flags(png: "https://flagcdn.com/w320/it.png"),
            area: 301340
        ),
        Country(
            name: Country.Name(common: "Spain"),
            translations: Country.Translations(fra: Country.Translations.Translation(common: "Espagne")),
            capital: ["Madrid"],
            population: 47000000,
            flags: Country.Flags(png: "https://flagcdn.com/w320/es.png"),
            area: 505992
        )
    ]
    
    NavigationStack {
        QuizView(countries: mockCountries)
    }
}

