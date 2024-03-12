//
//  Cotization.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation

class Cotization {
    
    let arsToUsd:Float = 0.0012
    let arsToMxn:Float = 0.020
    let arsToSol:Float = 0.0044
    
    let usdToArs:Float = 846.27
    let usdToMxn:Float = 16.87
    let usdToSol:Float = 3.72

    let mxnToArs:Float = 50.18
    let mxnToUsd:Float = 0.059
    let mxnToSol:Float = 0.32
    
    let solToArs:Float = 227.49
    let solToUsd:Float = 0.27
    let solToMxn:Float = 4.53
    
    
    func operationA2Usd(valor:Float) -> Float {
        let result = valor * arsToUsd
        return result
    }
    

}
