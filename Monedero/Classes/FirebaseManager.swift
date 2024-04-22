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
    
    static let shared = FirebaseManager()
    
        
    //Metodo update para actualizar datos de datos guardados bajo un ID
    func updateData(user:User) {
        let db = Firestore.firestore()
        if let id = user.id {
            let docRef = db.collection(user.email).document(id)
          do {
            try docRef.setData(from: user)
          }
          catch {
            print(error)
          }
        }
    }
    
    
    //MARK: - setData
    
    //Metodo para almacenar el objeto Wallet en FireStore
    func setData(user: User) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(user.email)
        do {
            try collectionRef.addDocument(from: user)
        }
        catch {
            print(error)
        }
    }
    
    
    
    
}
