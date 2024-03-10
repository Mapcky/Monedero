//
//  Trader.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 07/03/2024.
//

import Foundation
import UIKit

class Trader: UIViewController {
    
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
    @IBOutlet weak var lDestiny1: UITextField!
    @IBOutlet weak var lDestiny2: UITextField!
    @IBOutlet weak var lDestiny3: UITextField!
    
    var country: String?
    var balance: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        countryView()
        imageArrow.image = UIImage(systemName:"arrow.right")
        arrow2.image = UIImage(systemName: "arrow.right")
        arrow3.image = UIImage(systemName: "arrow.right")
        fOrigin1.text = "1"
        fOrigin2.text = "1"
        fOrigin3.text = "1"
        if let myBalance = balance {
            balanceNumber.text = "$ \(String(myBalance))"
        } else {
            balanceNumber.text = "ERROR"
        }
    }
    
    
    func countryView (){
        switch country {
        case "Argentina": 
            myImage.image = UIImage(named: "Argentina")
            lDestiny1.placeholder = String(cotizacion.arsToUsd)
            lDestiny2.placeholder = String(cotizacion.arsToMxn)
            lDestiny3.placeholder = String(cotizacion.arsToSol)
            break
        case "USA":
            myImage.image = UIImage(named: "EEUU")
            break
        case "Mexico":
            myImage.image = UIImage(named: "Mexico")
            break
        case "Peru":
            myImage.image = UIImage(named: "Peru")
            break
        default:
            balanceNumber.text = "ERROR"
            break
        }

        
    }
}
