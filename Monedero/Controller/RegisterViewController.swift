//
//  RegisterViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    //TextFields Outlets
    @IBOutlet weak var arsField: UITextField!
    @IBOutlet weak var usdField: UITextField!
    @IBOutlet weak var mxnField: UITextField!
    @IBOutlet weak var solField: UITextField!
    
    //Variables
    var wallet :Wallet?
    var email :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arsField.delegate = self
        usdField.delegate = self
        mxnField.delegate = self
        solField.delegate = self
        
        arsField.text = "0"
        usdField.text = "0"
        mxnField.text = "0"
        solField.text = "0"
        
    }
    
    
    
    
    //MARK: - deposit
    
  //Funcion deposit, obtiene los datos de los textfield y los guarda en firebase bajo el email obtenido en LoginViewController
    @IBAction func deposit(_ sender: Any) {
        if let ars = Float(arsField.text ?? "0"), let usd = Float(usdField.text ?? "0"), let mxn = Float(mxnField.text ?? "0"), let sol = Float(solField.text ?? "0") {
            
            //Boolean que definiran cuantas tarjetas se mostrarán
            var booleanArs = true
            var booleanUsd = true
            var booleanMxn = true
            var booleanSol = true
            
            if (ars == 0) {
                booleanArs = false
            }
            if (usd == 0) {
                booleanUsd = false
            }
            if (mxn == 0) {
                booleanMxn = false
            }
            if (sol == 0) {
                booleanSol = false
            }
            
            let c1 = Currency(amount: ars, country: .Ars, isActive: booleanArs, usdCotization: 0.0012)
            let c2 = Currency(amount: usd, country: .Usd, isActive: booleanUsd, usdCotization: 1)
            let c3 = Currency(amount: mxn, country: .Mxn, isActive: booleanMxn, usdCotization: 0.060)
            let c4 = Currency(amount: sol, country: .Sol, isActive: booleanSol, usdCotization: 0.27)
            
            wallet = Wallet(money: [c1,c2,c3,c4])
            storeData(whale: self.wallet!)
            performSegue(withIdentifier: "2Main", sender: sender)
        }
        
    }
    
    
    //MARK: - prepare
    
    //Se envia el email para luego recuperar los datos de FireStore en MainView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let mail = email{
            destino.email = mail
            //Se oculta el boton back del NavigationController en MainView para evitar volver a la pantalla de registro
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    
    
    //MARK: - TextField Methods
    
    
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Si el textField está vacío, establecer su texto como "0"
        if textField.text == "" {
            textField.text = "0"
        }
    }
    
    
    
    
    //MARK: - storeData
    
    //Metodo para almacenar el objeto Wallet en FireStore
    func storeData(whale: Wallet) {
        let db = Firestore.firestore()
        if let mail = email {
            let collectionRef = db.collection(mail)
            do {
                try collectionRef.addDocument(from: whale)
            }
            catch {
                print(error)
            }
        }
    }
    
}

