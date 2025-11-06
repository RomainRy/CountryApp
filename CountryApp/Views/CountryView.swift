//
//  CountryView.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct CountryView: View {
    @State private var viewModel = CountryViewModel()
    @State private var showQuiz = false
    
    var body: some View {
        VStack(spacing: 0) {
            SearchText(
                placeholder: "Rechercher un pays",
                text: $viewModel.searchText,
                icon: "magnifyingglass"
            )
            .padding()
            
            if viewModel.isLoading {
                Spacer()
                Loading(message: "Chargement des pays...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                EmptyState(message: errorMessage, icon: "exclamationmark.triangle")
                Spacer()
            } else if viewModel.filteredCountries.isEmpty {
                Spacer()
                EmptyState(message: "Aucun pays trouvé")
                Spacer()
            } else {
                List(viewModel.filteredCountries) { country in
                    CountryCard(
                        flagURL: country.flags.png,
                        countryName: country.displayName,
                        capital: country.displayCapital,
                        showArrow: true
                    )
                    .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .listRowSeparator(.hidden)
                    .background(
                        NavigationLink(destination: CountryDetailView(country: country)) {
                            EmptyView()
                        }
                        .opacity(0)
                    )
                }
                .listStyle(.plain)
            }
        }
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {
                Text("Pays du Monde")
                    .font(.system(size: 24, weight: .bold))
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                PrimaryButton(title: "Quiz", style: .primary) {
                    showQuiz = true
                }
                .frame(width: 100)
            }
        }

        .sheet(isPresented: $showQuiz) {
            NavigationStack {
                QuizView(countries: viewModel.countries)
            }
        }
        .task {
            await viewModel.loadCountries()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CountryView()
    }
    .environment(CountryViewModel.preview)
}




