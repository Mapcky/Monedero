//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 11/03/2024.
//

import UIKit

class End: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var myBalance: Balance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.hidesBackButton = true
        image.image = UIImage(systemName: "checkmark.square.fill")
        
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
