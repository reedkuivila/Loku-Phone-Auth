//
//  CountryData.swift
//  Loku
//
//  Created by reed kuivila on 3/24/23.
//

// file to manage the country phone number data from CountryNumbers.json

import Foundation

struct CountryData: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    static let allCountry: [CountryData] = Bundle.main.decode("CountryNumbers.json")
    static let example = allCountry[0]
}
