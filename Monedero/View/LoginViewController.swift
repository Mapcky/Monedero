//
//  LoginViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: ProtocolsViewController {

    //TextFields Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    //TextFields Buttons
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
    }
    
    //MARK: - Register
    //Registra un usuario usando FirebaseAuth, se envia el email a Register para su uso
    @IBAction func regBA(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: sender)
    }
    
    
    
    //MARK: - Login
    //Login, una vez verificados los datos de login mediante FirebaseAuth, procede a la pantalla Main
    @IBAction func logBA(_ sender: UIButton) {
        if let email = emailField.text, let pass = passField.text {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                if let error = error as NSError? {
                    // Manejar el error de inicio de sesión
                    switch error.code {
                    case AuthErrorCode.invalidEmail.rawValue:
                        strongSelf.showAlert(title: "Error", message: "Correo electrónico inválido")
                    case AuthErrorCode.userNotFound.rawValue:
                        strongSelf.showAlert(title: "Error", message: "Usuario no encontrado")
                    case AuthErrorCode.wrongPassword.rawValue:
                        strongSelf.showAlert(title: "Error", message: "Contraseña incorrecta")
                    default:
                        strongSelf.showAlert(title: "Error", message: error.localizedDescription)
                    }
                    return
                }
                // Inicio de sesión exitoso, continuar con la navegación
                strongSelf.performSegue(withIdentifier: "Main", sender: sender)
            }
        }
    }
    
    // Función para mostrar una alerta
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - prepare
    //Prepare envia el email del login a mainView para que este peuda recuprar los datos de dicho usuario luego
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destino = segue.destination as? MainView{
            destino.email = emailField.text
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    
    // Anular la función textField(_:shouldChangeCharactersIn:replacementString:)
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Devolver true para permitir cambios de texto
        return true
    }

    // Definir validateNumericInput como nil para evitar su uso
    override func validateNumericInput(textField: UITextField, replacementString string: String) -> Bool {
        // Siempre devolver true para permitir cualquier entrada
        return true
    }
    
}
