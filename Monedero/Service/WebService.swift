//
//  WebService.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 30/01/2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case noData
}

class WebService {
    
    func getConversions(completion: @escaping (Result<UsdConversions, NetworkError>) -> Void) {
        // Crear la URL a partir de la cadena
        guard let url = URL.urlGetConversions() else {
            completion(.failure(.badURL))
            return
        }
        
        // Crear una tarea de URLSession para obtener los datos JSON
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let conversionResponse = try? JSONDecoder().decode(UsdConversions.self, from: data)
            
            
            DispatchQueue.main.async {
                if let conversionResponse = conversionResponse {
                    completion(.success(conversionResponse))
                }
            }
        }.resume()
    }
    
}
