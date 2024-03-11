//
//  Balance.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation

class Balance {
    let ars: Int
    let usd: Int
    let mxn: Int
    let sol: Int
    
    
    init(ars: Int, usd: Int, mxn: Int, sol: Int) {
        self.ars = ars
        self.usd = usd
        self.mxn = mxn
        self.sol = sol
    }
}
