//
//  ProtocolsViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/06/2024.
//

import UIKit

class ProtocolsViewController: UIViewController, UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Llamar a resignFirstResponder() en el UITextField para ocultar el teclado
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ocultar el teclado cuando se presiona "return" en el teclado
        textField.resignFirstResponder()
        return true
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

}
