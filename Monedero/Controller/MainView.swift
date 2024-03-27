//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 05/03/2024.
//

import UIKit
import FirebaseFirestore


class MainView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var navigation: UINavigationItem!
    //@IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var wallet :[Currency]?
    private let db = Firestore.firestore()
    var email: String?

    let cotization = Cotization()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.hidesBackButton = true
     //   loading.startAnimating()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        gotData {[weak self] in
            // Una vez que los datos se hayan cargado, actualiza la vista
            self?.collectionView.reloadData()}

       // self.loading.stopAnimating()
       // self.loading.isHidden = true
        
        
    }


    @IBAction func buttonAction(_ sender: Any) {
        performSegue(withIdentifier: "traderView", sender: sender)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? Trader, let buttonPressed = sender as? UIButton {
                if buttonPressed.tag == 0 {
                    destino.countryCotization = CotizacionPais(pais: .Arg, exc1: cotization.arsToUsd, exc2: cotization.arsToMxn, exc3: cotization.arsToSol)
                //    destino.balance = myBalance
                }
                else if buttonPressed.tag == 1{
                    destino.countryCotization = CotizacionPais(pais: .Usa, exc1: cotization.usdToArs, exc2: cotization.usdToMxn, exc3: cotization.usdToSol)
              //      destino.balance = myBalance
                }
                else if buttonPressed.tag == 2{
                    destino.countryCotization = CotizacionPais(pais: .Mex, exc1: cotization.mxnToArs, exc2: cotization.mxnToUsd, exc3: cotization.mxnToSol)
             //       destino.balance = myBalance
                }
                else if buttonPressed.tag == 3{
                    destino.countryCotization = CotizacionPais(pais: .Per, exc1: cotization.solToArs, exc2: cotization.solToUsd, exc3: cotization.solToMxn)
            //        destino.balance = myBalance
                }
        }
    }
    
    
    
    func gotData(completion: @escaping () -> Void) {
        if let mail = email {
            
            db.collection("Wallets").document(mail).getDocument {document, error in
                if (error as NSError?) != nil {
                    
                }
                else {
                    if let document = document {
                        let data = document.data()
                        let cArg = Currency(balance:  Float(data?["Ars"] as? String ?? "0"), origin: .Ars)
                        let cUsd = Currency(balance:  Float(data?["Usd"] as? String ?? "0"), origin: .Usd)
                        let cMxn = Currency(balance:  Float(data?["Mxn"] as? String ?? "0"), origin: .Mxn)
                        let cSol = Currency(balance:  Float(data?["Sol"] as? String ?? "0"), origin: .Sol)
                        self.wallet = [cArg,cUsd,cMxn,cSol]
                        completion()
                    }
                    
                }
            }
        }
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallet?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! MyCollectionViewCell
        if let wallets = wallet {
            cell.countryLabel.text = wallets[indexPath.row].origin.rawValue
            cell.moneyLabel.text = String(wallets[indexPath.row].balance!)
            cell.moneyLabel.textColor = .white
            cell.backgroundColor = .lightGray
            cell.layer.cornerRadius = 30
        }
            return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width  // Aquí puedes ajustar el ancho de las tarjetas según tus necesidades
        let height = collectionView.bounds.height // Aquí puedes ajustar el alto de las tarjetas según tus necesidades
        return CGSize(width: width, height: height)
    }
    
    
    
    
    
}

