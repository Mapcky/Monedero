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
                    destino.country = "Argentina"
                    destino.balance = myBalance.ars
                }
                else if buttonPressed.tag == 1{
                    destino.country = "USA"
                    destino.balance = myBalance.usd
                }
                else if buttonPressed.tag == 2{
                    destino.country = "Mexico"
                    destino.balance = myBalance.mxn
                }
                else if buttonPressed.tag == 3{
                    destino.country = "Peru"
                    destino.balance = myBalance.sol
                }
            }
        }
    }
    
    
}

