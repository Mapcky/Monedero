//
//  usdConversions.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 29/01/2025.
//

import Foundation

struct UsdConversions: Decodable {
    var usd : usd
    
    struct usd :Decodable {
        var ars : Double
        var usd : Double = 1
        var mxn : Double
        var pen : Double
        var eur : Double
    }
}
