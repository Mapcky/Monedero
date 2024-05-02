//
//  RegisterViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//


import UIKit
import FirebaseAuth


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    //TextFields Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var moneyInput: UITextField!
    
    
    //Variables
    var user :User?
    var wallet : [Currency] = []
    var selectedCountry : Country?
    var selectedCurrency : Currency?
    private var menuActions = [UIAction]()
    let enumCountries = Country.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
        nameField.delegate = self
        moneyInput.delegate = self
        setMenuButton()
    }
    
    
    
    
    //MARK: - deposit
    
  //Funcion deposit, obtiene los datos de los textfield y los guarda en firebase bajo el email obtenido en LoginViewController
    @IBAction func deposit(_ sender: Any) {
        if let email = emailField.text, let pass = passField.text, let name = nameField.text, let money = moneyInput.text, let sCountry = selectedCountry {
            Auth.auth().createUser(withEmail: email, password: pass) {
                (result, error) in
                if error == nil {
                    
                    self.selectedCurrency = Currency(amount: (Float (money) ?? 0.0), country: sCountry, isActive: true)
                    self.wallet.append(self.selectedCurrency!)
                    self.user = User(email: email, name: name, wallet: self.wallet)
                    
                    FirebaseManager.shared.setUserData(user: self.user!)
                    self.performSegue(withIdentifier: "2Main", sender: sender)
                } else {}
            }
        }
    }
    
    
    //MARK: - prepare
    
    //Se envia el email para luego recuperar los datos de FireStore en MainView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let mail = user?.email{
            destino.email = mail
            //Se oculta el boton back del NavigationController en MainView para evitar volver a la pantalla de registro
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    
    
    //Se crean los items del menu desplegable del boton y liga dicho menú a este
    func setMenuButton() {
        for selector in enumCountries{
            let action = UIAction(title : selector.rawValue, handler: {action in self.handleMenuSelection(selector.rawValue)})
            menuActions.append(action)
        }
        let menu = UIMenu(children: menuActions)
        menuButton.menu = menu
        selectedCountry = enumCountries.first
    }
    
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        // busca el enum que coincida con el actual seleccionado por el boton
        for enums in enumCountries {
            if menuButton.currentTitle == enums.rawValue {
                selectedCountry = enums
            }
        }
    }

    /*
    // Método del protocolo UITextFieldDelegate que se llama cada vez que se cambia el texto en el campo de texto
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Llama a la función para validar si el texto es numérico con un punto decimal
        return validateNumericInput(textField: textField, replacementString: string)
    }
    
    // Función para validar si el texto ingresado es numérico con un punto decimal
    func validateNumericInput(textField: UITextField, replacementString string: String) -> Bool {
        // Obtener el texto completo después de la edición
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: NSRange(location: 0, length: currentText.length), with: string)
        
        // Permitir números enteros o números con un punto decimal
        return newText.isEmpty || (Double(newText) != nil)
    }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Llamar a resignFirstResponder() en el UITextField para ocultar el teclado
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ocultar el teclado cuando se presiona "return" en el teclado
        textField.resignFirstResponder()
        return true
    }
}

