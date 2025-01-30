//
//  UserViewModel.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 29/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    
    var user: User?
    var dataRetrieved = Observable<Void>()
    
    var onUserUpdated: ((User?) -> Void)?
    var onError: ((String) -> Void)?

    
    func getUserData(email: String) {
        
        // Obtener el documento especificado por el correo electrónico
        db.collection("Users").document(email)
            .getDocument { [weak self] (documentSnapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    self.onError?("Error al obtener el documento: \(error.localizedDescription)")
                    return
                }
                
                 guard let document = documentSnapshot, document.exists else {
                       self.onError?("No existe el usuario con este correo.")
                       return
                   }
                DispatchQueue.main.async {
                    do {
                        self.user = try document.data(as: User.self)
                        self.dataRetrieved.notify(with: ())
                        
                    } catch {
                        self.onError?("Error al decodificar datos del usuario.")
                    }
                }
        }
    }
    /*
    func setUserData() {
        guard let user = user else { return }
        let userRef = db.collection("Users").document(user.email)

        do {
            try userRef.setData(from: user)
        } catch let error {
            print("Error adding user: \(error)")
        }
    }
    */
    
}
