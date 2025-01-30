//
//  URL+Extensions.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 30/01/2025.
//

import Foundation

extension URL {
    static func urlGetConversions() -> URL? {
        return URL(string: "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json")
    }
}
