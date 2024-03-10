//
//  Balance.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation

class Balance {
    var ars: Int
    var usd: Int
    var mxn: Int
    var sol: Int
    
    
    init(ars: Int, usd: Int, mxn: Int, sol: Int) {
        self.ars = ars
        self.usd = usd
        self.mxn = mxn
        self.sol = sol
    }
}
