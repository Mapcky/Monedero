//
//  Currency.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//

import Foundation


class Currency {
    
    var balance: Float?
    var origin: Country
    
    
    
    enum Country :String {
        case Argentina = "ARS"
        case Usa = "USD"
        case Mexico = "MXN"
        case Peru = "SOL"
    }
    
    init(balance: Float? = nil, origin: Country) {
        self.balance = balance
        self.origin = origin
    }
}
