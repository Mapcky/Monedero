//
//  cotizacionPais.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 11/03/2024.
//

import Foundation

class CotizacionPais {
    
    let country: OpcionesPosibles
    let exc1: Float
    let exc2: Float
    let exc3: Float
    let excInverse1: Float
    let excInverse2: Float
    let excInverse3: Float
    
    
    enum OpcionesPosibles: String {
        case Arg = "Ars"
        case Usa = "Usd"
        case Mex = "Mxn"
        case Per = "Sol"
    }
    
    init(pais: OpcionesPosibles, exc1: Float, exc2: Float, exc3: Float , excI1: Float, excI2: Float, excI3: Float){
        self.country = pais
        self.exc1 = exc1
        self.exc2 = exc2
        self.exc3 = exc3
        self.excInverse1 = excI1
        self.excInverse2 = excI2
        self.excInverse3 = excI3
    }
}

    
