//
//  CountryDetailView.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import SwiftUI
import DesignSystem

struct CountryDetailView: View {
    @State private var viewModel: CountryDetailViewModel
    
    init(country: Country) {
        _viewModel = State(initialValue: CountryDetailViewModel(country: country))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Drapeau
                AsyncImage(url: URL(string: viewModel.country.flags.png)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 150)
                .cornerRadius(12)
                .shadow(radius: 8)
                
                Text(viewModel.country.displayName)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 16) {
                    InfoRow(title: "Capitale", value: viewModel.displayCapital)
                    InfoRow(title: "Population", value: viewModel.formattedPopulation)
                    InfoRow(title: "Superficie", value: viewModel.formattedArea)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(viewModel.country.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body.bold())
        }
    }
}

#Preview {
    NavigationStack {
        CountryDetailView(country: Country(
            name: Country.Name(common: "France"),
            translations: Country.Translations(fra: Country.Translations.Translation(common: "France")),
            capital: ["Paris"],
            population: 67000000,
            flags: Country.Flags(png: "https://flagcdn.com/w320/fr.png"),
            area: 551695
        ))
    }
}
