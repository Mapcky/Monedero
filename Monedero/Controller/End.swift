//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 11/03/2024.
//

import UIKit

class End: UIViewController {
    
    //images
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var downArrow: UIImageView!
    @IBOutlet weak var upArrow: UIImageView!
    
    
    //labels
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var plusLabel: UILabel!
    
    
    
    
    //variables
    var myBalance: Balance?
    var suma: String?
    var resta: String?
    var email: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.hidesBackButton = true
        image.image = UIImage(systemName: "checkmark.square.fill")
        upArrow.image = UIImage(systemName: "arrow.up")
        downArrow.image = UIImage(systemName: "arrow.down")
        if let plus = suma, let minus = resta {
            downLabel.text = minus
            plusLabel.text = plus
        }
        
    }

    @IBOutlet weak var controller: UINavigationItem!
    

    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "homeSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView, let mail = email {
            destino.email = mail
        }
    }
}
