//
//  LoginViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //TextFields Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    //TextFields Buttons
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Register
    //Registra un usuario usando FirebaseAuth, se envia el email a Register para su uso
    @IBAction func regBA(_ sender: UIButton) {
        if let email = emailField.text, let pass = passField.text {
            Auth.auth().createUser(withEmail: email, password: pass) {
                (result, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "register", sender: sender)

                } else {}
                
            }
        }
    }
    
    
    
    //MARK: - Login
    //Login, una vez verificados los datos de login mediante FirebaseAuth, procede a la pantalla Main
    @IBAction func logBA(_ sender: UIButton) {
        if let email = emailField.text, let pass = passField.text {
            Auth.auth().signIn(withEmail: email, password: pass) {
                (result, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "Main", sender: sender)
                } else {}
            }
        }
    }
    
    
    
    
    //MARK: - prepare
    //Prepare pertinentes para enviar los datos ya sea hacia RegisterViewController o MainView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? RegisterViewController{
            destino.email = emailField.text
        }
        
        if let destino = segue.destination as? MainView{
            destino.email = emailField.text
        }
    }
    
    
    
    
}
