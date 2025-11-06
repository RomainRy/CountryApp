//
//  CountryModel.swift
//  CountryApp
//
//  Created by ROYER Romain on 05/11/2025.
//

import Foundation

struct Country: Codable, Identifiable {
    var id: String { name.common }
    
    let name: Name
    let translations: Translations?
    let capital: [String]?
    let population: Int
    let flags: Flags
    let area: Double
    
    struct Name: Codable {
        let common: String
    }
    
    struct Translations: Codable {
        let fra: Translation?
        
        struct Translation: Codable {
            let common: String
        }
    }
    
    struct Flags: Codable {
        let png: String
    }
    
    var displayName: String {
        translations?.fra?.common ?? name.common
    }
    
    var displayCapital: String {
        capital?.first ?? "Inconnue"
    }
}
