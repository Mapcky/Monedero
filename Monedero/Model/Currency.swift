//
//  NewCurrency.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 03/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Currency :Codable {
    
    var amount : Float
    var country : Country
    var isActive : Bool
    
    
    init(amount: Float, country: Country, isActive: Bool){
        self.amount = amount
        self.country = country
        self.isActive = isActive
    }
    
}

public enum Country : String, Codable, CaseIterable {
    case Ars = "ARS🇦🇷"
    case Usd = "USD🇺🇸"
    case Mxn = "MXN🇲🇽"
    case Pen = "PEN🇵🇪"
    case Eur = "EUR🇪🇺"
    //case Gbp = "GBP🏴󠁧󠁢󠁥󠁮󠁧󠁿"
}
