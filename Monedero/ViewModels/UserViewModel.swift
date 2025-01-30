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
    
    var onUserUpdated: ((User?) -> Void)?
    var onError: ((String) -> Void)?
    
    
    var activeCurrencies: [Currency] {
        return user?.wallet.filter { $0.isActive == true } ?? []
    }
    
    // MARK: - GetData
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
    
    // MARK: - LOGIN
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
            DispatchQueue.main.async {
                strongSelf.dataRetrieved.notify(with: ())
            }
        }
    }
    
    // MARK: - REGISTER
    func register(email: String, password: String, name: String, wallet: Currency) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (result, error) in
            
            // Manejo de errores
            if let authError = error as NSError? {
                var errorMessage = "Hubo un error desconocido. Por favor, intenta de nuevo."
                switch authError.code {
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "El correo electrónico proporcionado es inválido."
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    errorMessage = "Este correo electrónico ya está registrado. Intenta con otro."
                case AuthErrorCode.weakPassword.rawValue:
                    errorMessage = "La contraseña es demasiado débil. Usa al menos 6 caracteres."
                default:
                    errorMessage = authError.localizedDescription
                }
                
                
                // Llamamos a la función de error del ViewModel para que notifique al controlador
                self.onError?(errorMessage)
                return
            }
            DispatchQueue.main.async {
                let userRef = self.db.collection("Users").document(email)
                self.user = User(email: email, name: name, wallet: [wallet])
                do {
                    try userRef.setData(from: self.user)
                    self.dataRetrieved.notify(with: ())
                } catch let error {
                    print("Error adding user: \(error)")
                }
            }
        }
    }
    
    // MARK: - DOTRANSACTION
    func doTransaction(originAmount: String, destinyAmount: String, selectedOriginCurrency: Currency, selectedDestinyCurrency: Currency) {
        guard let user = self.user else { return  }
        guard let originCurrency = activeCurrencies.first(where: { $0.country == selectedOriginCurrency.country }) else { return  }
        
        // Reducir el monto en la moneda de origen
        originCurrency.amount -= (Double(originAmount) ?? 0)
        
        // Verificar si la moneda de destino ya existe en el wallet
        var destinyCurrency = activeCurrencies.first(where: { $0.country == selectedDestinyCurrency.country })
        
        if destinyCurrency == nil {
            destinyCurrency = Currency(amount: 0, country: selectedDestinyCurrency.country, isActive: true)
            user.wallet.append(destinyCurrency!)
        }
        
        
        // Aumentar el monto en la moneda de destino
        destinyCurrency?.amount += (Double(destinyAmount) ?? 0)
        DispatchQueue.main.async {
            let userRef = self.db.collection("Users").document(user.email)
            do {
                
                try userRef.setData(from: user)
                self.dataRetrieved.notify(with: ())
                
            } catch let error {
                print("Error adding user: \(error)")
            }
        }
    }


}
