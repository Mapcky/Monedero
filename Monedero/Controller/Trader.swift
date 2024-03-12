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
    
    var balance: Balance?
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
        imageArrow.image = UIImage(systemName:"arrowshape.left.arrowshape.right.fill")
        arrow2.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        arrow3.image = UIImage(systemName: "arrowshape.left.arrowshape.right.fill")
        fOrigin1.text = "1"
        fOrigin2.text = "1"
        fOrigin3.text = "1"
        countryView()
    }
    
    
    @IBAction func editando(_ sender: Any) {
        if let countryObject = countryCotization, let fieldModify = sender as? UITextField {
                switch fieldModify.tag {
                case 0:
                    if let change = fOrigin1.text, let blns = balance {
                        let calculo = (Float(change) ?? 0) * countryObject.exchange1
                        fDestiny1.text = String(format:"%.2f",calculo)
                        if countryObject.country == .Arg{
                            if (Float(change) ?? 0) > blns.ars {
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
                    }
                    break
                    
                case 2:
                    if let change = fOrigin3.text {
                        let calculo = (Float(change) ?? 0) * countryObject.exchange3
                        fDestiny3.text = String(format:"%.2f",calculo)
                    }
                    break
         
                case 3:
                    if let change = fDestiny1.text {
                        let calculo = (Float(change) ?? 0) / countryObject.exchange1
                        fOrigin1.text = String(format:"%.2f",calculo)
                    }
                    break
                    
                case 4:
                    if let change = fDestiny2.text {
                        let calculo = (Float(change) ?? 0) / countryObject.exchange2
                        fOrigin2.text = String(format:"%.2f",calculo)
                    }
                    break
                    
                case 5:
                    if let change = fDestiny3.text {
                        let calculo = (Float(change) ?? 0) / countryObject.exchange3
                        fOrigin3.text = String(format:"%.2f",calculo)
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
        if let blncs = balance, let change = fOrigin1.text, let change2 = fDestiny1.text {
            blncs.ars = blncs.ars - (Float(change) ?? 0)
            blncs.usd = blncs.usd + (Float(change2) ?? 0)

        }
        performSegue(withIdentifier: "endSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? End, let blncs = balance {
                destino.myBalance = blncs
                
       /*     if let buttonPressed = sender as? UIButton {
                if buttonPressed.tag == 0 {
                    destino.countryCotization = CotizacionPais(pais: .Arg, exc1: cotization.arsToUsd, exc2: cotization.arsToMxn, exc3: cotization.arsToSol, excI1: cotization.usdToArs, excI2: cotization.mxnToArs, excI3: cotization.solToArs)
                    destino.balance = myBalance.ars
                }
                else if buttonPressed.tag == 1{
                    destino.countryCotization = CotizacionPais(pais: .Usa, exc1: cotization.usdToArs, exc2: cotization.usdToMxn, exc3: cotization.usdToSol, excI1: cotization.arsToUsd, excI2: cotization.mxnToUsd, excI3: cotization.solToUsd)
                    destino.balance = myBalance.usd
                }
                else if buttonPressed.tag == 2{
                    destino.countryCotization = CotizacionPais(pais: .Mex, exc1: cotization.mxnToArs, exc2: cotization.mxnToUsd, exc3: cotization.mxnToSol, excI1: cotization.arsToMxn, excI2: cotization.usdToMxn, excI3: cotization.solToMxn)
                    destino.balance = myBalance.mxn
                }
                else if buttonPressed.tag == 3{
                    destino.countryCotization = CotizacionPais(pais: .Per, exc1: cotization.solToArs, exc2: cotization.solToUsd, exc3: cotization.solToMxn, excI1: cotization.arsToSol, excI2: cotization.usdToSol, excI3: cotization.mxnToSol)
                    destino.balance = myBalance.sol
                }*/
            }
        }
    
    //field end editing

    
    
    
    
    
    
    
}
