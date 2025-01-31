//
//  depositView.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 02/05/2024.
//

import UIKit

class DepositView: ProtocolsViewController {
    
    @IBOutlet weak var inputMoneyField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var depositButton: UIButton!
    
    var viewModel :UserViewModel?
    private let enumCountries = Country.allCases
    private var menuActions = [UIAction]()
    private var selectedCurrency :Currency?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setPopButton()
        inputMoneyField.delegate = self
        
        viewModel?.dataRetrieved.bind(to: self) { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "endFromDeposit", sender: nil)
        }
    }
    
    @IBAction func depositAction(_ sender: Any) {
        guard let inputMoney = inputMoneyField.text,
              let money = Double(inputMoney), money > 0,
              let currency = selectedCurrency else {
            self.showAlert(title: "Error", message: "Ingrese una cantidad válida.")
            return
        }
        
        viewModel?.deposit(input: inputMoney, selectedCurrency: currency)
        depositButton.isEnabled = false
    }
    
    func setPopButton() {
        menuActions = enumCountries.map { country in
            UIAction(title: country.rawValue) { _ in
                self.handleMenuSelection(country.rawValue)
            }
        }
        selectedCurrency = Currency(amount: 0, country: .Ars, isActive: true)
        let menu = UIMenu(children: menuActions)
        countryButton.menu = menu
    }
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        if let selected = enumCountries.first(where: { $0.rawValue == option }) {
            selectedCurrency?.country = selected
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End ,let usr = viewModel{
            destino.email = usr.email
            destino.suma = inputMoneyField.text
            destino.resta = ""
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    //MARK: - editingField
    
    //Control de los Fields
    @IBAction func editingField(_ sender: Any) {
        guard let text = inputMoneyField.text, let amount = Double(text), amount > 0 else {
            depositButton.isEnabled = false
            return
        }
        depositButton.isEnabled = true
    }
    
}
