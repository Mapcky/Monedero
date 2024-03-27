//
//  RegisterViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 27/03/2024.
//


import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegisterViewController: UIViewController {
    @IBOutlet weak var arsField: UITextField!
    @IBOutlet weak var usdField: UITextField!
    @IBOutlet weak var mxnField: UITextField!
    @IBOutlet weak var solField: UITextField!
    
    var email :String?
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arsField.text = "0"
        usdField.text = "0"
        mxnField.text = "0"
        solField.text = "0"
        
    }
    
  
    @IBAction func deposit(_ sender: Any) {
        if let mail = email, let ars = arsField.text, let usd = usdField.text, let mxn = mxnField.text, let sol = solField.text {
            db.collection("Wallets").document(mail).setData(["Ars" : ars, "Usd" : usd, "Mxn" : mxn, "Sol" : sol])
            performSegue(withIdentifier: "2Main", sender: sender)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? MainView{
            if let mail = email {
                destino.email = mail
                destino.navigationItem.hidesBackButton = true
            }
        }
    }
   
}

