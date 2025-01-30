//
//  FirebaseManager.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 09/04/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    
    //static let shared = FirebaseManager()
    
    func setUserData(user: User) {
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(user.email)

        do {
            try userRef.setData(from: user)
        } catch let error {
            print("Error adding user: \(error)")
        }
    }
    
    
    func getUserData(email: String, completion: @escaping (User?, Error?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("Users").document(email)
        
        // Obtener el documento especificado por el correo electrónico
        documentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error al obtener el documento: \(error)")
                completion(nil, error) // Llamada al bloque de finalización con nil para el usuario y el error
            } else {
                guard let document = documentSnapshot else {
                    print("No existe el documento")
                    completion(nil, nil) // Llamada al bloque de finalización con nil para el usuario y el error
                    return
                }
                // Intenta convertir el documento en un objeto User
                if let user = try? document.data(as: User.self) {
                    completion(user, nil) // Llamada al bloque de finalización con el usuario y nil para el error
                } else {
                    print("El documento no contiene datos válidos de usuario")
                    completion(nil, nil) // Llamada al bloque de finalización con nil para el usuario y el error
                }
            }
        }
    }
    
    
    //MARK: - getResources
    func getResources(completion: @escaping (String?, String?, Error?) -> Void) {
        let db = Firestore.firestore()
        let collection = db.collection("Resources")
        var apiURL:String?
        var apiKey:String?
        // Obtener todos los documentos de la colección
        collection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al obtener documentos: \(error)")
                completion(nil,nil,error)
            } else {
                // Verificar si hay documentos en la colección
                guard let documents = querySnapshot?.documents else {
                    print("No se encontraron documentos")
                    completion(nil,nil,error)
                    return
                }
                
                // Si hay documentos, obtener el primer documento
                if let document = documents.first {
                    let data = document.data()
                    apiURL = data["apiURL"] as? String ?? ""
                    apiKey = data["apiKey"] as? String ?? ""
                }
                completion(apiURL,apiKey,nil)
            }
        }
    }
    
}
