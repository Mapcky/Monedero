//
//  LoginViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? RegisterViewController{
            destino.email = emailField.text
            
            
        }
        if let destino = segue.destination as? MainView{
            destino.email = emailField.text
            
            
        }
    }
    
    
    
    
}
