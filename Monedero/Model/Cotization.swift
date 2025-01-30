//
//  Cotization.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 09/04/2024.
//

import Foundation


class Cotization {
    
    var value: Double
    var country : Country
    
    
    init(value: Double, country: Country) {
        self.value = value
        self.country = country
    }
}
