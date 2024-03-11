//
//  Trader.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation
import UIKit

class Trader: UIViewController {
    
    //variables
    /*
     var origin1: Float = 1
     var origin2: Float = 1
     var origin3: Float = 1
     var destiny1: Float = 0
     var destiny2: Float = 0
     var destiny3: Float = 0*/
    
    var country: String?
    var balance: Int?
    
    let cotizacion = Cotization()
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
        imageArrow.image = UIImage(systemName:"arrow.right")
        arrow2.image = UIImage(systemName: "arrow.right")
        arrow3.image = UIImage(systemName: "arrow.right")
        fOrigin1.text = "1"
        fOrigin2.text = "1"
        fOrigin3.text = "1"
        countryView()
        if let myBalance = balance {
            balanceNumber.text = "$ \(String(myBalance))"
        } else {
            balanceNumber.text = "ERROR"
        }
        
        
    }
    
    
    @IBAction func editando(_ sender: Any) {
        if let buttonPressed = sender as? UITextField {
            switch buttonPressed.tag {
            case 0:
                if let origin6 = fOrigin1.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.arsToUsd
                    fDestiny1.text = String(calculo)
                }
                break
            case 1:
                if let origin6 = fOrigin2.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.arsToMxn
                    fDestiny2.text = String(calculo)
                }
                break
                
            case 2:
                if let origin6 = fOrigin3.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.arsToSol
                    fDestiny3.text = String(calculo)
                }
                break
                
            case 3:
                if let origin6 = fDestiny1.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.usdToArs
                    fOrigin1.text = String(calculo)
                }
                break
                
            case 4:
                if let origin6 = fDestiny2.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.mxnToArs
                    fOrigin2.text = String(calculo)
                }
                break
                
            case 5:
                if let origin6 = fDestiny3.text {
                    let calculo = (Float(origin6) ?? 0) * cotizacion.solToArs
                    fOrigin3.text = String(calculo)
                }
                break
                
            default:
                break
            }
        }
    }
    
    func countryView (){
        switch country {
        case "Argentina": 
            myImage.image = UIImage(named: "Argentina")
            //text field destiny
            fDestiny1.text = String(cotizacion.arsToUsd)
            fDestiny2.text = String(cotizacion.arsToMxn)
            fDestiny3.text = String(cotizacion.arsToSol)
            
            //labels
            (label1.text, label3.text, label5.text) = ("ARS","ARS","ARS")
            label2.text = "USD"
            label4.text = "MXN"
            label6.text = "SOL"
            break
        case "USA":
            myImage.image = UIImage(named: "EEUU")
            fDestiny1.text = String(cotizacion.usdToArs)
            fDestiny2.text = String(cotizacion.usdToMxn)
            fDestiny3.text = String(cotizacion.usdToSol)
            
            //labels
            (label1.text, label3.text, label5.text) = ("USD","USD","USD")
            label2.text = "ARS"
            label4.text = "MXN"
            label6.text = "SOL"
            break
        case "Mexico":
            myImage.image = UIImage(named: "Mexico")
            fDestiny1.text = String(cotizacion.mxnToArs)
            fDestiny2.text = String(cotizacion.mxnToUsd)
            fDestiny3.text = String(cotizacion.mxnToSol)
            
            //labels
            (label1.text, label3.text, label5.text) = ("MXN","MXN","MXN")
            label2.text = "ARS"
            label4.text = "USD"
            label6.text = "SOL"
            break
        case "Peru":
            myImage.image = UIImage(named: "Peru")
            fDestiny1.text = String(cotizacion.solToArs)
            fDestiny2.text = String(cotizacion.solToUsd)
            fDestiny3.text = String(cotizacion.solToMxn)
            
            //labels
            (label1.text, label3.text, label5.text) = ("SOL","SOL","SOL")
            label2.text = "ARS"
            label4.text = "USD"
            label6.text = "MXN"
            break
        default:
            balanceNumber.text = "ERROR"
            break
        }

        
    }
}
