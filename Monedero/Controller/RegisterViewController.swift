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
    let enumCountries : [Country] = [.Ars,.Usd,.Mxn,.Pen,.Eur]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setWallet()
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
                    
                    FirebaseManager.shared.setData(user: self.user!)
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
    }
    
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        // busca el objeto currency que coincida con el actual seleccionado por el boton
        for enums in enumCountries {
            if menuButton.currentTitle == enums.rawValue {
                selectedCountry = enums
            }
        }
    }
    /*
    //Se crea el objeto wallet que luego será ligado al user, necesaria para el funcionamiento del menuButton
    func setWallet() {
        let c1 = Currency(amount: 0, country: .Ars, isActive: false)
        let c2 = Currency(amount: 0, country: .Usd, isActive: false)
        let c3 = Currency(amount: 0, country: .Mxn, isActive: false)
        let c4 = Currency(amount: 0, country: .Pen, isActive: false)
        let c5 = Currency(amount: 0, country: .Eur, isActive: false)
        
        wallet = [c1,c2,c3,c4,c5]
        
    }
    */
}

