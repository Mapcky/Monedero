//
//  depositView.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 02/05/2024.
//

import UIKit

class DepositView: UIViewController {
    
    @IBOutlet weak var inputMoneyField: UITextField!
    @IBOutlet weak var countryButton: UIButton!
    
    var user :User?
    private let enumCountries = Country.allCases
    private var menuActions = [UIAction]()
    private var selectedCurrency :Currency?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopButton()

    }
    
    @IBAction func depositAction(_ sender: Any) {
        performSegue(withIdentifier: "endFromDeposit", sender: sender)
    }
    
    func setPopButton() {
        
        for selector in enumCountries{
            let actions = UIAction(title : selector.rawValue, handler: {action in self.handleMenuSelection(selector.rawValue) })
            menuActions.append(actions)
        }
        selectedCurrency = Currency(amount: 0, country: .Ars, isActive: true)
        let menu = UIMenu(children: menuActions)
        countryButton.menu = menu
    }
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        // Obtiene el título del botón cuando una opcion es seleccionada
        for enums in enumCountries {
            if countryButton.currentTitle == enums.rawValue {
                selectedCurrency!.country = enums
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End ,let usr = user{
            let (inputMoney) = doTransaction()
            destino.email = usr.email
            destino.suma = inputMoney
            destino.resta = ""
            destino.navigationItem.hidesBackButton = true
            FirebaseManager.shared.setUserData(user: usr)
        }
    }
    
    func doTransaction() -> (String?) {
        if let inputMoney = inputMoneyField.text, let usr = user {
                var exists:Bool = false
                
                for myWallet in usr.wallet {
                    if myWallet.country == selectedCurrency!.country {
                        exists = true
                        selectedCurrency = myWallet
                    }
                }
                
                if exists == false {
                    selectedCurrency!.amount = (Float(inputMoney) ?? 0)
                    usr.wallet.append(selectedCurrency!)
                }
                else {
                    selectedCurrency!.amount += (Float(inputMoney) ?? 0)
                }
                return (inputMoney)
        }
        return(nil)
    }
    
    
}
