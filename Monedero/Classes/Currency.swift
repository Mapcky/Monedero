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
        case Ars = "Argentina"
        case Usd = "United States"
        case Mxn = "Mexico"
        case Sol = "Peru"
    }
    
    init(balance: Float? = nil, origin: Country) {
        self.balance = balance
        self.origin = origin
    }
}
