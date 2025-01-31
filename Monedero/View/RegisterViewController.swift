//
//  RegisterViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//


import UIKit


class RegisterViewController: ProtocolsViewController {
    
    
    //TextFields Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var moneyInput: UITextField!
    
    
    //Variables
    private var viewModel = UserViewModel()
    var selectedCurrency : Currency?
    private var menuActions = [UIAction]()
    private let enumCountries = Country.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passField.delegate = self
        nameField.delegate = self
        moneyInput.delegate = self
        setMenuButton()
        
        //Manejo de Errores
        viewModel.onError = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showAlert(title: "Error", message: errorMessage)
        }
        
        viewModel.dataRetrieved.bind(to: self) { [weak self] _ in
            guard let self = self, self.isViewLoaded, self.view.window != nil else { return }
            self.performSegue(withIdentifier: "2Main", sender: nil)
        }
    }
    
    
    
    
    //MARK: - register
    @IBAction func register(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let pass = passField.text, !pass.isEmpty,
              let name = nameField.text, !name.isEmpty,
              let moneyText = moneyInput.text, !moneyText.isEmpty,
              let money = Double(moneyText), money > 0,
              let sCurrency = selectedCurrency
        else {
            self.showAlert(title: "Error", message: "Todos los campos son obligatorios y la cantidad debe ser válida.")
            return
        }
        
        let wallet = Currency(amount: money, country: sCurrency.country, isActive: true)
        
        viewModel.register(email: email, password: pass, name: name, wallet: wallet)
    }
    
    
    //MARK: - prepare
    
    //Se envia el email para luego recuperar los datos de FireStore en MainView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let mail = viewModel.user?.email {
            destino.email = mail
            //Se oculta el boton back del NavigationController en MainView para evitar volver a la pantalla de registro
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    
    
    //Se crean los items del menu desplegable del boton y liga dicho menú a este
    func setMenuButton() {
        menuActions = enumCountries.map { country in
            UIAction(title: country.rawValue) { _ in
                self.handleMenuSelection(country.rawValue)
            }
        }
        selectedCurrency = Currency(amount: 0, country: .Ars, isActive: true)
        let menu = UIMenu(children: menuActions)
        menuButton.menu = menu
    }
    
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        if let selected = enumCountries.first(where: { $0.rawValue == option }) {
            selectedCurrency?.country = selected
        }
    }
    
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Solo el moneyInput necesita la validación numérica
        if textField == moneyInput {
            return validateNumericInput(textField: textField, replacementString: string)
        }
        return true
    }
}

