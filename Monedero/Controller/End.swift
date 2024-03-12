//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 11/03/2024.
//

import UIKit

class End: UIViewController {
    
    var myBalance: Balance? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.hidesBackButton = true
        
        
    }

    @IBOutlet weak var controller: UINavigationItem!
    

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "homeSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let balance = myBalance {
            destino.myBalance = balance
        }
    }
}
