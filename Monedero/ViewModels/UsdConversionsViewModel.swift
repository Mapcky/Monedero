//
//  usdConversionsViewModel.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 29/01/2025.
//

import Foundation

class UsdConversionViewModel {

    // MARK: - PROPERTIES
    var usdConversions: UsdConversions?
    private var webService = WebService()
    var dataRetrieved = Observable<Void>()
    var cotizations: [Cotization] = []
    var onError: ((String) -> Void)?
    
    // MARK: - FUNCTIONS
    func getConversions() {
        webService.getConversions { result in
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                    self.usdConversions = data
                    self.cotizations = Cotization.fromUsdConversions(data)
                    self.dataRetrieved.notify(with: ())
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - EXTENSION
extension Cotization {
    static func fromUsdConversions(_ conversions: UsdConversions) -> [Cotization] {
        return [
            Cotization(value: 1/conversions.usd.ars, country: Country.Ars),
            Cotization(value: conversions.usd.usd, country: Country.Usd),
            Cotization(value: 1/conversions.usd.mxn, country: Country.Mxn),
            Cotization(value: 1/conversions.usd.pen, country: Country.Pen),
            Cotization(value: 1/conversions.usd.eur, country: Country.Eur)
        ]
    }
}
