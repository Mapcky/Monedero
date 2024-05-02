//
//  ConversionResult.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 09/04/2024.
//

import Foundation


// Estructura para el JSON
class ConversionResult: Codable {
    let result: Conversion
    let status: String
}

class Conversion: Codable {
    let from: String
    let conversion: [CurrencyConversion]
}

class CurrencyConversion: Codable {
    var to: String
    let date: String
    let rate: Double
}

