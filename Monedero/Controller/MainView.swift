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
    @IBOutlet weak var navigation: UINavigationItem!
    var myBalance = Balance(ars: 0, usd: 5000, mxn: 100, sol: 0)
    let cotization = Cotization()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.hidesBackButton = true
        arsLabel.text = "$Ars    \(String(format:"%.2f",myBalance.ars))"
        usdLabel.text = "$Usd    \(String(format:"%.2f",myBalance.usd))"
        mxnLabel.text = "$Mxn    \(String(format:"%.2f",myBalance.mxn))"
        solLabel.text = "$Sol     \(String(format:"%.2f",myBalance.sol))"
    }


    @IBAction func buttonAction(_ sender: Any) {
        performSegue(withIdentifier: "traderView", sender: sender)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? Trader, let buttonPressed = sender as? UIButton {
                if buttonPressed.tag == 0 {
                    destino.countryCotization = CotizacionPais(pais: .Arg, exc1: cotization.arsToUsd, exc2: cotization.arsToMxn, exc3: cotization.arsToSol)
                    destino.balance = myBalance
                }
                else if buttonPressed.tag == 1{
                    destino.countryCotization = CotizacionPais(pais: .Usa, exc1: cotization.usdToArs, exc2: cotization.usdToMxn, exc3: cotization.usdToSol)
                    destino.balance = myBalance
                }
                else if buttonPressed.tag == 2{
                    destino.countryCotization = CotizacionPais(pais: .Mex, exc1: cotization.mxnToArs, exc2: cotization.mxnToUsd, exc3: cotization.mxnToSol)
                    destino.balance = myBalance
                }
                else if buttonPressed.tag == 3{
                    destino.countryCotization = CotizacionPais(pais: .Per, exc1: cotization.solToArs, exc2: cotization.solToUsd, exc3: cotization.solToMxn)
                    destino.balance = myBalance
                }
        }
    }
    
    
}

