//
//  cotizacionPais.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 11/03/2024.
//

import Foundation

class CotizacionPais {
    
    let country: OpcionesPosibles
    let exchange1: Float
    let exchange2: Float
    let exchange3: Float

    
    
    enum OpcionesPosibles: String {
        case Arg = "Ars"
        case Usa = "Usd"
        case Mex = "Mxn"
        case Per = "Sol"
    }
    
    init(pais: OpcionesPosibles, exc1: Float, exc2: Float, exc3: Float){
        self.country = pais
        self.exchange1 = exc1
        self.exchange2 = exc2
        self.exchange3 = exc3

    }
}

    
