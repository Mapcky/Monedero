//
//  NewTrader.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 03/04/2024.
//

import UIKit


class NewTrader: UIViewController,UITextFieldDelegate {
    
    //Variables
    var user : User?
    var myCotizations: [Cotization]?
    private let enumCountries = Country.allCases
    
    //Button & Menu Outlets
    private var menuActions = [UIAction]()
    private var menuActionsB2 = [UIAction]()
    @IBOutlet weak var excButton: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var popButton: UIButton!
    
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
        excButton.isEnabled = false
        setPopButton()
    }
    
    //MARK: - SetPopButtons
    
    //Armado de las menu actions de los botones
    func setPopButton() {
        
        for selector in user!.wallet{
            if selector.isActive == true {
                let action = UIAction(title : selector.country.rawValue, handler: {action in self.handleMenuSelection(selector.country.rawValue)})
                menuActions.append(action)
            }
        }
        
        for selector in enumCountries{
            let actionB2 = UIAction(title : selector.rawValue, handler: {action in self.handleMenuSelection(selector.rawValue) })
            menuActionsB2.append(actionB2)
        }
        
        
        let menu = UIMenu(children: menuActions)
        let menub2 = UIMenu(children: menuActionsB2)
        popButton.menu = menu
        b2.menu = menub2
        
        
        originCurrency = user?.wallet.first
        
        
        //Currency de la derecha, cambiara sus atributos segun su uso
        destinyCurrency = Currency(amount: 0, country: .Ars, isActive: true)
        
        if let conversion = myCotizations {
            for conv in conversion {
                if originCurrency!.country.rawValue.contains(conv.country!) {
                    leftCountry = conv
                }
                if destinyCurrency!.country.rawValue.contains(conv.country!) {
                    rightCountry = conv
                }
            }
        }
    }
    
    
    //MARK: - sameCountry
    
    //Comprueba si ambos botones han elegido la misma opcion y se deshabilita el boton Transaccion
    /*
    func sameCountry() {
        if let b1Title = popButton.currentTitle, let b2Tittle = b2.currentTitle {
            
            if(b1Title == b2Tittle) {
                excButton.isEnabled = false
            }
            else {
                excButton.isEnabled = true
            }
        }
    }
    */
    
    //MARK: - editingField
    
    //Control de los Fields
    @IBAction func editingField(_ sender: Any) {
        if let fieldModify = sender as? UITextField {
            
            switch fieldModify.tag {
            case 0:
                if (Float (originField.text ?? "0") ?? 0) > originCurrency!.amount || (Float (originField.text ?? "0") ?? 0) <= 0  || popButton.currentTitle == b2.currentTitle{
                    excButton.isEnabled = false
                }
                else {
                    excButton.isEnabled = true
                }
                let calculo = (Float(originField.text!) ?? 0) * (leftCountry?.value ?? 0)
                destinyField.text = String(format: "%.3f",calculo / (rightCountry?.value ?? 0))
                break
                
            case 1:
                let calculo2 = (Float(destinyField.text!) ?? 0) * (rightCountry?.value ?? 0)
                originField.text = String(format: "%.3f",calculo2 / (leftCountry?.value ?? 0))
                
                if (Float (originField.text ?? "0") ?? 0) > originCurrency!.amount || (Float (destinyField.text ?? "0") ?? 0) <= 0  || popButton.currentTitle == b2.currentTitle{
                    excButton.isEnabled = false
                }
                else {
                    excButton.isEnabled = true
                }
                
                break
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func exchangeAction(_ sender: Any) {
        performSegue(withIdentifier: "End", sender: sender)
    }
    
    
    //MARK: - HandleMenuSelection
    //Se Ejecuta cada vez que se cambia la opcion seleccionada de los menues
    func handleMenuSelection(_ option: String) {
        // Obtiene el título del botón cuando una opcion es seleccionada
        excButton.isEnabled = false
        for bag in user!.wallet {
            if popButton.currentTitle == bag.country.rawValue {
                originCurrency = bag
            }
        }
        for enums in enumCountries {
            if b2.currentTitle == enums.rawValue {
                destinyCurrency!.country = enums
            }
        }
        if let cotization = myCotizations {
            for conv in cotization {
                if popButton.currentTitle!.contains( conv.country!){
                    leftCountry = conv
                }
                if b2.currentTitle!.contains(conv.country!) {
                    rightCountry = conv
                }
            }
            destinyField.text = ""
            originField.text = ""
        }
    }
    
    
    //MARK: - prepare
    // "Realiza la transaccion" busca si existe un objeto currency del usuario para
    // modificar su valor, en caso de no existir se crea un nuevo objeto y se agrega
    // a su wallet, luego se guardan los cambios en Firestore y se envia a la siguiente vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End ,let usr = user{
            let (originAmount,destinyAmount) = doTransaction()
            destino.email = usr.email
            destino.suma = destinyAmount
            destino.resta = originAmount
            destino.navigationItem.hidesBackButton = true
            FirebaseManager.shared.setUserData(user: usr)
        }
    }
    
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Llamar a resignFirstResponder() en el UITextField para ocultar el teclado
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ocultar el teclado cuando se presiona "return" en el teclado
        textField.resignFirstResponder()
        return true
    }
    
    func doTransaction() -> (String?,String?) {
        if let originAmount = originField.text, let destinyAmount = destinyField.text, let usr = user {
            if let oCurrency = originCurrency {
                oCurrency.amount -=  (Float(originAmount) ?? 0)
                var exists:Bool = false
                
                for myWallet in usr.wallet {
                    if myWallet.country == destinyCurrency!.country {
                        exists = true
                        destinyCurrency = myWallet
                    }
                }
                
                if exists == false {
                    destinyCurrency!.amount += (Float(destinyAmount) ?? 0)
                    usr.wallet.append(destinyCurrency!)
                }
                else {
                    destinyCurrency!.amount += (Float(destinyAmount) ?? 0)
                }
                return (originAmount,destinyAmount)
            }
        }
        return(nil,nil)
    }
    
}

