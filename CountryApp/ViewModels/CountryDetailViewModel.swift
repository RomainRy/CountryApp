//
//  CountryDetailViewModel.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import Foundation
import Observation

@Observable
class CountryDetailViewModel {
    let country: Country
    
    var formattedPopulation: String {
        country.population.formatted()
    }
    
    var formattedArea: String {
        "\(country.area.formatted()) km²"
    }
    
    var displayCapital: String {
        country.displayCapital
    }
    
    init(country: Country) {
        self.country = country
    }
}
