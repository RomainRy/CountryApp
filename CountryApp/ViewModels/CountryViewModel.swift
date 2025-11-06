//
//  CountryViewModel.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import Foundation
import Observation

protocol CountryDataProvider {
    func fetchCountries() async throws -> [Country]
}

class RealCountryProvider: CountryDataProvider {
    func fetchCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,translations,capital,population,flags,area")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Country].self, from: data)
    }
}

class MockCountryProvider: CountryDataProvider {
    func fetchCountries() async throws -> [Country] {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        return [
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
    }
}

@Observable
class CountryViewModel {
    private let provider: CountryDataProvider
    
    var countries: [Country] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var errorMessage: String?
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        }
        return countries.filter {
            $0.displayName.lowercased().contains(searchText.lowercased())
        }
    }
    
    init(provider: CountryDataProvider = RealCountryProvider()) {
        self.provider = provider
    }
    
    @MainActor
    func loadCountries() async {
        isLoading = true
        errorMessage = nil
        
        do {
            countries = try await provider.fetchCountries()
                .sorted(by: { $0.displayName < $1.displayName })
        } catch {
            errorMessage = "Erreur lors du chargement des pays"
            print("Erreur :", error)
        }
        
        isLoading = false
    }
}

extension CountryViewModel {
    static var preview: CountryViewModel {
        CountryViewModel(provider: MockCountryProvider())
    }
}
