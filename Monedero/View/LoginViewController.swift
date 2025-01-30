//
//  LoginViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//

import UIKit

class LoginViewController: ProtocolsViewController {

    //TextFields Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    //TextFields Buttons
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    
    // MARK: - PROPERTIES
    
    private var viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
        
        //Manejo de Errores
        viewModel.onError = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: errorMessage)
        }
        
        //Login Confirmado, perform segue
        viewModel.dataRetrieved.bind(to: self) { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "Main", sender: nil)
        }
    }
    
    //MARK: - Register
    //Registra un usuario usando FirebaseAuth, se envia el email a Register para su uso
    @IBAction func regBA(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: sender)
    }
    
    
    
    //MARK: - Login
    @IBAction func logBA(_ sender: UIButton) {
        guard let email = emailField.text, let pass = passField.text else { return }
        viewModel.login(email: email, password: pass)
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
}
