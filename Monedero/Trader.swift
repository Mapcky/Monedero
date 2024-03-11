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
    
    var balance: Int?
    var countryCotization: CotizacionPais?
    
    
    
   // let cotizacion = Cotization()
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
        if let countryObject = countryCotization {
            if let fieldModify = sender as? UITextField {
                switch fieldModify.tag {
                case 0:
                    if let change = fOrigin1.text {
                        let calculo = (Float(change) ?? 0) * countryObject.exc1
                        fDestiny1.text = String(calculo)
                    }
                    break
                case 1:
                    if let change = fOrigin2.text {
                        let calculo = (Float(change) ?? 0) * countryObject.exc2
                        fDestiny2.text = String(calculo)
                    }
                    break
                    
                case 2:
                    if let change = fOrigin3.text {
                        let calculo = (Float(change) ?? 0) * countryObject.exc3
                        fDestiny3.text = String(calculo)
                    }
                    break
         
                case 3:
                    if let change = fDestiny1.text {
                        let calculo = (Float(change) ?? 0) * countryObject.excInverse1
                        fOrigin1.text = String(calculo)
                    }
                    break
                    
                case 4:
                    if let change = fDestiny2.text {
                        let calculo = (Float(change) ?? 0) * countryObject.excInverse2
                        fOrigin2.text = String(calculo)
                    }
                    break
                    
                case 5:
                    if let change = fDestiny3.text {
                        let calculo = (Float(change) ?? 0) * countryObject.excInverse3
                        fOrigin3.text = String(calculo)
                    }
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    func countryView (){
        if let countryObject = countryCotization {
            switch countryObject.country {
            case .Arg:
                myImage.image = UIImage(named: "Argentina")
                //labels
                (label1.text, label3.text, label5.text) = ("ARS","ARS","ARS")
                label2.text = "USD"
                label4.text = "MXN"
                label6.text = "SOL"
                
                break
            case .Usa:
                myImage.image = UIImage(named: "EEUU")
                //labels
                (label1.text, label3.text, label5.text) = ("USD","USD","USD")
                label2.text = "ARS"
                label4.text = "MXN"
                label6.text = "SOL"
                break
            case .Mex:
                myImage.image = UIImage(named: "Mexico")
                //labels
                (label1.text, label3.text, label5.text) = ("MXN","MXN","MXN")
                label2.text = "ARS"
                label4.text = "USD"
                label6.text = "SOL"
                break
            case .Per:
                myImage.image = UIImage(named: "Peru")
                //labels
                (label1.text, label3.text, label5.text) = ("SOL","SOL","SOL")
                label2.text = "ARS"
                label4.text = "USD"
                label6.text = "MXN"
                break

            }
            //Fields izq
            fDestiny1.text = String(countryObject.exc1)
            fDestiny2.text = String(countryObject.exc2)
            fDestiny3.text = String(countryObject.exc3)
            }
        }
}
