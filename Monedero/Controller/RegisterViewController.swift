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
    @IBOutlet weak var arsField: UITextField!
    @IBOutlet weak var usdField: UITextField!
    @IBOutlet weak var mxnField: UITextField!
    @IBOutlet weak var solField: UITextField!
    
    var email :String?
    private let db = Firestore.firestore()
    
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
    
  //Funcion deposit, obtiene los datos de los textfield y los guarda en firebase bajo el email obtenido en LoginViewController
    @IBAction func deposit(_ sender: Any) {
        if let mail = email, let ars = arsField.text, let usd = usdField.text, let mxn = mxnField.text, let sol = solField.text {
            db.collection("Wallets").document(mail).setData([
                "Ars" : ars,
                "Usd" : usd,
                "Mxn" : mxn,
                "Sol" : sol])
            performSegue(withIdentifier: "2Main", sender: sender)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let mail = email{
            destino.email = mail
            destino.navigationItem.hidesBackButton = true
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

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Si el textField está vacío, establecer su texto como "0"
        if textField.text == "" {
            textField.text = "0"
        }
    }
    
    
}

