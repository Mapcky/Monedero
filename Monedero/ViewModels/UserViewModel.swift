//
//  UserViewModel.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 29/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    
    var user: User?
    var dataRetrieved = Observable<Void>()
    var onLoginSuccess: (() -> Void)?
    
    var onUserUpdated: ((User?) -> Void)?
    var onError: ((String) -> Void)?

    
    var activeCurrencies: [Currency] {
        return user?.wallet.filter { $0.isActive == true } ?? []
    }
    
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
    
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError? {
                let errorMessage: String
                switch error.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "Correo electrónico inválido"
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "Usuario no encontrado"
                case AuthErrorCode.wrongPassword.rawValue:
                    errorMessage = "Contraseña incorrecta"
                default:
                    errorMessage = error.localizedDescription
                }
                strongSelf.onError?(errorMessage) // Pass error to the ViewController
                return
            }
            strongSelf.dataRetrieved.notify(with: ())
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
