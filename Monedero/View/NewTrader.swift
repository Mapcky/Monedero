//
//  NewTrader.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 03/04/2024.
//

import UIKit


class NewTrader: ProtocolsViewController {
    
    //Variables
    var userViewModel : UserViewModel?
    var myCotizations: [Cotization]?
    private let enumCountries = Country.allCases
    
    //Button & Menu Outlets
    private var menuActionsButtonLeft = [UIAction]()
    private var menuActionsButtonRight = [UIAction]()
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var countryRightButton: UIButton!
    @IBOutlet weak var countryLeftButton: UIButton!
    
    //Selected items variables
    private var originCurrency :Currency?
    private var destinyCurrency :Currency?
    private var leftCountry: Cotization?
    private var rightCountry: Cotization?
    
    
    //TextFields Outlets
    @IBOutlet weak var originField: UITextField!
    @IBOutlet weak var destinyField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        originField.delegate = self
        destinyField.delegate = self
        exchangeButton.isEnabled = false
        setUpCountryButtons()
        
        userViewModel?.dataRetrieved.bind(to: self) { [weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "End", sender: nil)
        }
    }
    
    //MARK: - SetPopButtons
    
    //Armado de las menu actions de los botones
    func setUpCountryButtons() {
        guard let wallet = userViewModel?.activeCurrencies else { return }
        
        menuActionsButtonLeft = wallet.map { currency in
            UIAction(title: currency.country.rawValue) { _ in
                self.handleMenuSelection(currency.country.rawValue)
            }
        }
        
        
        menuActionsButtonRight = enumCountries.map { country in
            UIAction(title: country.rawValue) { _ in
                self.handleMenuSelection(country.rawValue)
            }
        }
        
        countryLeftButton.menu = UIMenu(children: menuActionsButtonLeft)
        countryRightButton.menu = UIMenu(children: menuActionsButtonRight)
        
        originCurrency = wallet.first
        destinyCurrency = Currency(amount: 0, country: .Ars, isActive: true)
        
        (leftCountry, rightCountry) = userViewModel?.updateCotizations(for: originCurrency?.country ?? .Ars, destinyCountry: destinyCurrency?.country ?? .Ars, cotizations: myCotizations ?? []) ?? (nil, nil)
    }
    
    
    //MARK: - editingField
    
    //Control de los Fields
    @IBAction func editingField(_ sender: Any) {
        if let fieldModify = sender as? UITextField {
            switch fieldModify.tag {
            case 0:
                if (Double (originField.text ?? "0") ?? 0) > originCurrency!.amount || (Double (originField.text ?? "0") ?? 0) <= 0 || countryLeftButton.currentTitle == countryRightButton.currentTitle{
                    exchangeButton.isEnabled = false
                }
                else {
                    exchangeButton.isEnabled = true
                }
                let calculo = (Double(originField.text!) ?? 0) * (leftCountry?.value ?? 0)
                destinyField.text = String(format: "%.3f",calculo / (rightCountry?.value ?? 0))
                
            case 1:
                let calculo = (Double(destinyField.text!) ?? 0) * (rightCountry?.value ?? 0)
                originField.text = String(format: "%.3f",calculo / (leftCountry?.value ?? 0))
                
                if (Double (originField.text ?? "0") ?? 0) > originCurrency!.amount || (Double (destinyField.text ?? "0") ?? 0) <= 0 || countryLeftButton.currentTitle == countryRightButton.currentTitle{
                    exchangeButton.isEnabled = false
                }
                else {
                    exchangeButton.isEnabled = true
                }
            default:
                break
            }
        }
    }
    
    
    @IBAction func exchangeAction(_ sender: Any) {
        guard let oAmount = originField.text, let dAmount = destinyField.text, let oCurrency = originCurrency, let dCurrency = destinyCurrency,
              let viewModel = userViewModel else { return }
        
        viewModel.doTransaction(originAmount: oAmount, destinyAmount: dAmount, selectedOriginCurrency: oCurrency, selectedDestinyCurrency: dCurrency)
        exchangeButton.isEnabled = false
    }
    
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        guard let wallet = userViewModel?.activeCurrencies else { return }
        
        exchangeButton.isEnabled = false
        originCurrency = wallet.first(where: { $0.country.rawValue == countryLeftButton.currentTitle })
        destinyCurrency?.country = enumCountries.first(where: { $0.rawValue == countryRightButton.currentTitle }) ?? .Ars
        (leftCountry, rightCountry) = userViewModel?.updateCotizations(for: originCurrency?.country ?? .Ars, destinyCountry: destinyCurrency?.country ?? .Ars, cotizations: myCotizations ?? []) ?? (nil, nil)
        destinyField.text = ""
        originField.text = ""
    }
    
    
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End, let userViewModel = userViewModel {
            destino.navigationItem.hidesBackButton = true
            destino.email = userViewModel.user?.email
            destino.suma = destinyField.text ?? "0"
            destino.resta = originField.text ?? "0"
        }
    }
    
    
}

