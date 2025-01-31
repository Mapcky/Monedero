//
//  ProfileViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 18/04/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        if let name = name {
            nameLabel.text = name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? LoginViewController {
            destino.navigationItem.hidesBackButton = true
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        performSegue(withIdentifier: "exit", sender: sender)
    }
    
}
