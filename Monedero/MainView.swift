//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 05/03/2024.
//

import UIKit

class MainView: UIViewController {

    @IBOutlet weak var arsLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var mxnLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    let myBalance = Balance(ars: 0, usd: 10000, mxn: 0, sol: 0)
    let cotization = Cotization()
    override func viewDidLoad() {
        super.viewDidLoad()
        arsLabel.text = "$Ars    \(String(myBalance.ars))"
        usdLabel.text = "$Usd    \(String(myBalance.usd))"
        mxnLabel.text = "$Mxn    \(String(myBalance.mxn))"
        solLabel.text = "$Sol     \(String(myBalance.sol))"
    }


    @IBAction func buttonAction(_ sender: Any) {
        performSegue(withIdentifier: "traderView", sender: sender)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? Trader {
            if let buttonPressed = sender as? UIButton {
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
                }
            }
        }
    }
    
    
}

