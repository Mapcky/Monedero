//
//  Cotization.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 09/04/2024.
//

import Foundation


class Cotization {
    
    var value: Float?
    var country : String?
    
    
    init(value: Float, country: String) {
        self.value = value
        self.country = country
    }
}
