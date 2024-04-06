//
//  ViewController.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 05/03/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


class MainView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Legacy variables
    private var myBalance: Balance?
    let cotization = Cotization()
    
    //Outlets
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    //Variables para actual funcionamiento
    var wallet :Wallet?
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        gotData {[weak self] in
            // Una vez que los datos se hayan cargado, actualiza la vista
            self?.loading.stopAnimating()
            self?.loading.isHidden = true
            self?.collectionView.reloadData()
            self?.oldSystem()}
    }

    
    
    //Accion de los botones 0 a 3
    @IBAction func buttonAction(_ sender: Any) {
        performSegue(withIdentifier: "traderView", sender: sender)
    }
    //Accion del boton 4, hacia el NewTrader
    @IBAction func NewTrader(_ sender: Any) {
        performSegue(withIdentifier: "2NewTrader", sender: sender)
    }
    
    
    //MARK: prepare
    //Override de prepare, se envian los datos necesariosa Trader
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? Trader, let buttonPressed = sender as? UIButton {
            
            //Se envian los datos necesarios para el antiguo sistema trader
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
            destino.email = email
        }
        
        //Se envian wallet y email para el actual funcionamiento de NewTrader
        if let destino = segue.destination as? NewTrader, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 4{
                destino.email = email
                destino.wallet = wallet!
            }
        }
        
    }
    
    
    // MARK: - gotData
    func gotData(completion: @escaping () -> Void) {
        if let mail = email {
            let db = Firestore.firestore()
            let collection = db.collection(mail)
            
            // Obtener todos los documentos de la colección
            collection.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error al obtener documentos: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No hay documentos")
                        return
                    }
                    //Itera sobre todos los documentos de la collection, sin embargo solo recuperaremos el unico que existe
                    for document in documents {
                        do {
                            if let whale = try? document.data(as: Wallet.self) {
                                self.wallet = whale
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource
    
    //Creacion de numero de tarjetas, segun cuantos items pertenezcan a el array de Currency
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count = 0
        if let w8 = wallet {
            for wall in w8.myMoney {
                if wall.isActive == true {
                    count += 1
                }
            }
            
        }
        return count
    }
    
    //Creacion de cada Cell del CollectionView, se da formato a labels y forma de la cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Filtrar los elementos del arreglo currency donde isActive es true
        let activeCurrencies = wallet?.myMoney.filter { $0.isActive == true }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! MyCollectionViewCell
        cell.countryLabel.text = activeCurrencies?[indexPath.row].country.rawValue
        cell.moneyLabel.text = "$ \(String(format: "%.2f",activeCurrencies?[indexPath.row].amount ?? 0))"
        cell.moneyLabel.textColor = .white
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 30
        
        
    
    return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    //Tamaño de cada celda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width  // Aquí puedes ajustar el ancho de las tarjetas según tus necesidades
        let height = collectionView.bounds.height // Aquí puedes ajustar el alto de las tarjetas según tus necesidades
        return CGSize(width: width, height: height)
    }
    
    
    
    
    
    
    
    
    
    // MARK: - LegacySystem
    func oldSystem() {
        var ars :Float = 0
        var usd :Float = 0
        var mxn :Float = 0
        var sol :Float = 0
        for w8 in wallet!.myMoney {
            
            if w8.country == .Ars {
                ars = w8.amount
            }
            if w8.country == .Usd {
                usd = w8.amount
            }
            if w8.country == .Mxn {
                mxn = w8.amount
            }
            if w8.country == .Sol {
                sol = w8.amount
            }
        }
        myBalance = Balance(ars: ars, usd: usd, mxn: mxn, sol: sol)
    }
    

}

