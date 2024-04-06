//
//  Balance.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation

class Balance {
    var ars: Float
    var usd: Float
    var mxn: Float
    var sol: Float
    
    
    init(ars: Float, usd: Float, mxn: Float, sol: Float) {
        self.ars = ars
        self.usd = usd
        self.mxn = mxn
        self.sol = sol
    }
}
