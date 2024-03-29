//
//  Trader.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class Trader: UIViewController, UITextFieldDelegate {
    
    var email: String?
    //private var wallets: [Currency]?
    var balance: Balance?
    var countryCotization: CotizacionPais?
    private let db = Firestore.firestore()
    
    //parte Superior
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var balanceNumber: UILabel!
    
    //Arrows
    @IBOutlet weak var imageArrow: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    
    //fields Origen
    @IBOutlet weak var fOrigin1: UITextField!
    @IBOutlet weak var fOrigin2: UITextField!
    @IBOutlet weak var fOrigin3: UITextField!
    
    
    //fields salida
    @IBOutlet weak var fDestiny1: UITextField!
    @IBOutlet weak var fDestiny2: UITextField!
    @IBOutlet weak var fDestiny3: UITextField!
    
    //Labels Info
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    //Buttons
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArrow.image = UIImage(systemName:"arrowshape.left.arrowshape.right.fill")
        arrow2.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        arrow3.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        fOrigin1.delegate = self
        fOrigin2.delegate = self
        fOrigin3.delegate = self
        fDestiny1.delegate = self
        fDestiny2.delegate = self
        fDestiny3.delegate = self
        fOrigin1.text = "1"
        fOrigin2.text = "1"
        fOrigin3.text = "1"
        button1.setBackgroundImage(imageWithColor(color: UIColor.lightGray), for: .disabled)
        button2.setBackgroundImage(imageWithColor(color: UIColor.lightGray), for: .disabled)
        button3.setBackgroundImage(imageWithColor(color: UIColor.lightGray), for: .disabled)
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        countryView()
    }
    
    
    @IBAction func editando(_ sender: Any) {
        if let countryObject = countryCotization, let fieldModify = sender as? UITextField, //CountryObject cotization from origin country
           
           let blns = balance{                                      //User wallet
            switch fieldModify.tag {                                //Switch of textfields
            case 0:
                if let change = fOrigin1.text {
                    let calculo = (Float(change) ?? 0) * countryObject.exchange1        //Control amount input < wallet
                    fDestiny1.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg{
                        if (Float(change) ?? 0) > blns.ars || (Float(change) ?? 0) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(change) ?? 0) > blns.usd || (Float(change) ?? 0) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(change) ?? 0) > blns.mxn || (Float(change) ?? 0) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(change) ?? 0) > blns.sol || (Float(change) ?? 0) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    
                }
                break
            case 1:
                if let change = fOrigin2.text {
                    let calculo = (Float(change) ?? 0) * countryObject.exchange2
                    fDestiny2.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg{
                        if  (Float(change) ?? 0) > blns.ars || (Float(change) ?? 0) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(change) ?? 0) > blns.usd || (Float(change) ?? 0) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(change) ?? 0) > blns.mxn || (Float(change) ?? 0) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(change) ?? 0) > blns.sol || (Float(change) ?? 0) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                }
                break
                
            case 2:
                if let change = fOrigin3.text {
                    let calculo = (Float(change) ?? 0) * countryObject.exchange3
                    fDestiny3.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg{
                        if (Float(change) ?? 0) > blns.ars || (Float(change) ?? 0) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(change) ?? 0) > blns.usd || (Float(change) ?? 0) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(change) ?? 0) > blns.mxn || (Float(change) ?? 0) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(change) ?? 0) > blns.sol || (Float(change) ?? 0) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    
                }
                break
                
            case 3:
                if let change = fDestiny1.text {
                    let calculo = (Float(change) ?? 0) / countryObject.exchange1
                    fOrigin1.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg{
                        if (Float(calculo)) > blns.ars || (Float(calculo)) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(calculo)) > blns.usd || (Float(calculo)) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(calculo)) > blns.mxn || (Float(calculo)) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(calculo)) > blns.sol || (Float(calculo)) < 1 {
                            button1.isEnabled = false
                        } else {
                            button1.isEnabled = true
                        }
                    }
                    
                }
                break
                
            case 4:
                if let change = fDestiny2.text {
                    let calculo = (Float(change) ?? 0) / countryObject.exchange2
                    fOrigin2.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg{
                        if (Float(calculo)) > blns.ars || (Float(calculo)) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(calculo)) > blns.usd || (Float(calculo)) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(calculo)) > blns.mxn || (Float(calculo)) < 1 {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(calculo)) > blns.sol || (Float(calculo)) < 1  {
                            button2.isEnabled = false
                        } else {
                            button2.isEnabled = true
                        }
                    }
                    
                }
                break
                
            case 5:
                if let change = fDestiny3.text {
                    let calculo = (Float(change) ?? 0) / countryObject.exchange3
                    fOrigin3.text = String(format:"%.2f",calculo)
                    if countryObject.country == .Arg {
                        if (Float(calculo)) > blns.ars || (Float(calculo)) < 1  {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Usa{
                        if (Float(calculo)) > blns.usd || (Float(calculo)) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Mex{
                        if (Float(calculo)) > blns.mxn || (Float(calculo)) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    if countryObject.country == .Per{
                        if (Float(calculo)) > blns.sol || (Float(calculo)) < 1 {
                            button3.isEnabled = false
                        } else {
                            button3.isEnabled = true
                        }
                    }
                    
                }
                break
                
            default:
                break
            }
        }
    }
    
    func countryView (){
        if let countryObject = countryCotization, let myBalance = balance {
            switch countryObject.country {
            case .Arg:
                myImage.image = UIImage(named: "Argentina")
                //labels
                (label1.text, label3.text, label5.text) = ("ARS","ARS","ARS")
                label2.text = "USD"
                label4.text = "MXN"
                label6.text = "SOL"
                //balance
                balanceNumber.text = "$ \(String(format:"%.2f",myBalance.ars))"
                break
            case .Usa:
                myImage.image = UIImage(named: "EEUU")
                //labels
                (label1.text, label3.text, label5.text) = ("USD","USD","USD")
                label2.text = "ARS"
                label4.text = "MXN"
                label6.text = "SOL"
                //balance
                balanceNumber.text = "$ \(String(format:"%.2f",myBalance.usd))"
                
                break
            case .Mex:
                myImage.image = UIImage(named: "Mexico")
                //labels
                (label1.text, label3.text, label5.text) = ("MXN","MXN","MXN")
                label2.text = "ARS"
                label4.text = "USD"
                label6.text = "SOL"
                //balance
                balanceNumber.text = "$ \(String(format:"%.2f",myBalance.mxn))"
                
                break
            case .Per:
                myImage.image = UIImage(named: "Peru")
                //labels
                (label1.text, label3.text, label5.text) = ("SOL","SOL","SOL")
                label2.text = "ARS"
                label4.text = "USD"
                label6.text = "MXN"
                //balance
                balanceNumber.text = "$ \(String(format:"%.2f",myBalance.sol))"
                
                break
                
            }
            //Fields Derecha
            fDestiny1.text = String(format:"%.3f",countryObject.exchange1)
            fDestiny2.text = String(format:"%.3f",countryObject.exchange2)
            fDestiny3.text = String(format:"%.3f",countryObject.exchange3)
        }
    }
    
    
    @IBAction func tradeButton(_ sender: Any) {
        performSegue(withIdentifier: "endSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End, let blncs = balance, let mail = email,
           let countryObject = countryCotization, let buttonPressed = sender as? UIButton{
            if countryObject.country == .Arg {
                switch buttonPressed.tag {
                case 0:
                    if let change = fOrigin1.text, let change2 = fDestiny1.text {
                        blncs.ars = blncs.ars - (Float(change) ?? 0)
                        blncs.usd = blncs.usd + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 1:
                    if let change = fOrigin2.text, let change2 = fDestiny2.text {
                        blncs.ars = blncs.ars - (Float(change) ?? 0)
                        blncs.mxn = blncs.mxn + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 2:
                    if let change = fOrigin3.text, let change2 = fDestiny3.text {
                        blncs.ars = blncs.ars - (Float(change) ?? 0)
                        blncs.sol = blncs.sol + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                default:
                    break
                }
            }
            else if countryObject.country == .Usa {
                switch buttonPressed.tag{
                case 0:
                    if let change = fOrigin1.text, let change2 = fDestiny1.text {
                        blncs.usd = blncs.usd - (Float(change) ?? 0)
                        blncs.ars = blncs.ars + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 1:
                    if let change = fOrigin2.text, let change2 = fDestiny2.text {
                        blncs.usd = blncs.usd - (Float(change) ?? 0)
                        blncs.mxn = blncs.mxn + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 2:
                    if let change = fOrigin3.text, let change2 = fDestiny3.text {
                        blncs.usd = blncs.usd - (Float(change) ?? 0)
                        blncs.sol = blncs.sol + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                default:
                    break
                }
            }

            else if countryObject.country == .Mex {
                switch buttonPressed.tag{
                case 0:
                    if let change = fOrigin1.text, let change2 = fDestiny1.text {
                        blncs.mxn = blncs.mxn - (Float(change) ?? 0)
                        blncs.ars = blncs.ars + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 1:
                    if let change = fOrigin2.text, let change2 = fDestiny2.text {
                        blncs.mxn = blncs.mxn - (Float(change) ?? 0)
                        blncs.usd = blncs.usd + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 2:
                    if let change = fOrigin3.text, let change2 = fDestiny3.text {
                        blncs.mxn = blncs.mxn - (Float(change) ?? 0)
                        blncs.sol = blncs.sol + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                default:
                    break
                }
            }
                                
            else if countryObject.country == .Per {
                switch buttonPressed.tag{
                case 0:
                    if let change = fOrigin1.text, let change2 = fDestiny1.text {
                        blncs.sol = blncs.sol - (Float(change) ?? 0)
                        blncs.ars = blncs.ars + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                case 1:
                    if let change = fOrigin2.text, let change2 = fDestiny2.text {
                    blncs.sol = blncs.sol - (Float(change) ?? 0)
                    blncs.usd = blncs.usd + (Float(change2) ?? 0)
                    destino.suma = change2
                    destino.resta = change
                }
                    break
                case 2:
                    if let change = fOrigin3.text, let change2 = fDestiny3.text {
                        blncs.sol = blncs.sol - (Float(change) ?? 0)
                        blncs.mxn = blncs.mxn + (Float(change2) ?? 0)
                        destino.suma = change2
                        destino.resta = change
                    }
                    break
                default:
                    break
                }
            }
            storeData(balance: blncs)
            destino.myBalance = blncs
            destino.email = mail
        }
    }
    
    
    func storeData(balance:Balance) {
        
        if let mail = email{
            db.collection("Wallets").document(mail).setData(["Ars" : String(format:"%.2f",balance.ars), "Usd" : String(format:"%.2f",balance.usd), "Mxn" : String(format:"%.2f",balance.mxn), "Sol" : String(format:"%.2f",balance.sol)])
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

    // Función para crear una imagen de un color sólido
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}


    

