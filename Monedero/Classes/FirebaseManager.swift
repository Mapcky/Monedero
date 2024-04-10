//
//  FirebaseManager.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 09/04/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
        
    //Metodo update para actualizar datos de datos guardados bajo un ID
    func updateData(email:String, wallet:Wallet) {
        let db = Firestore.firestore()
        if let id = wallet.id {
          let docRef = db.collection(email).document(id)
          do {
            try docRef.setData(from: wallet)
          }
          catch {
            print(error)
          }
        }
    }
    
    
    //MARK: - setData
    
    //Metodo para almacenar el objeto Wallet en FireStore
    func setData(email:String, wallet: Wallet) {
        let db = Firestore.firestore()
        let collectionRef = db.collection(email)
        do {
            try collectionRef.addDocument(from: wallet)
        }
        catch {
            print(error)
        }
    }
    
    
    
    
}
