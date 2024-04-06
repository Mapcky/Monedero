//
//  NewCurrency.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 03/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Currency :Codable{
    
    var amount : Float
    let country : Country
    var isActive : Bool
    let usdCotization : Float
    
    
    
    enum Country : String, Codable {
        
        case Ars = "ARS🇦🇷"
        case Usd = "USD🇺🇸"
        case Mxn = "MXN🇲🇽"
        case Sol = "SOL🇵🇪"
    }
    
    
    
    
    
    init(amount: Float, country: Country, isActive: Bool, usdCotization :Float){
        self.amount = amount
        self.country = country
        self.isActive = isActive
        self.usdCotization = usdCotization
    }
    
}
