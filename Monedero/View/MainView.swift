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
    
    // MARK: - Outlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tradeB: UIButton!
    @IBOutlet weak var depositB: UIButton!
    
    // MARK: - PROPERTIES
    private var viewModel = UserViewModel()
    private var conversionVM = UsdConversionViewModel()
    var email: String?

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        profileButton.isHidden = true
        profileButton.isUserInteractionEnabled = true
        tradeB.isHidden = true
        depositB.isHidden = true
        
        if let email = email {
            self.viewModel.getUserData(email: email)
            viewModel.dataRetrieved.bind(to: self) { _ in
                // Una vez que los datos se hayan cargado, actualiza la vista
                self.profileButton.setTitle("Hola \(self.viewModel.user?.name ?? "")", for: .normal)
                self.loading.stopAnimating()
                self.loading.isHidden = true
                self.collectionView.reloadData()
                self.profileButton.isHidden = false
            }
            //: Fb getUser
            
            conversionVM.getConversions()
            conversionVM.dataRetrieved.bind(to: self) { _ in
                self.tradeB.isHidden = false
                self.depositB.isHidden = false
            }

        }

    }//: ViewDidLoad

    @IBAction func depositAction(_ sender: Any) {
        performSegue(withIdentifier: "deposit", sender: sender)
    }
    
    
    //Accion del boton 4, hacia el NewTrader
    @IBAction func NewTrader(_ sender: Any) {
        performSegue(withIdentifier: "2NewTrader", sender: sender)
    }
    
    
    //MARK: prepare
    //Override de prepare, se envian los datos necesariosa Trader
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Se envian wallet y email para el actual funcionamiento de NewTrader
        if let destino = segue.destination as? NewTrader, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 0{
                destino.user = viewModel.user
                destino.myCotizations = conversionVM.cotizations
            }
        }
        if let destino = segue.destination as? DepositView, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 1{
                destino.user = viewModel.user
            }
        }
        if let destino = segue.destination as? ProfileViewController, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 2{
                destino.name = viewModel.user?.name
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    //Creacion de numero de tarjetas, segun cuantos items pertenezcan a el array de Currency
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let user = viewModel.user {
            for wallet in user.wallet {
                if wallet.isActive == true {
                    count += 1
                }
            }
        }
        return count
    }
    
    //MARK: - collectionView
    //Creacion de cada Cell del CollectionView, se da formato a labels y forma de la cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Filtrar los elementos del arreglo currency donde isActive es true
        let activeCurrencies = viewModel.user?.wallet.filter { $0.isActive == true }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! MyCollectionViewCell
        cell.countryLabel.text = activeCurrencies?[indexPath.row].country.rawValue
        cell.moneyLabel.text = "$ \(String(format: "%.2f",activeCurrencies?[indexPath.row].amount ?? 0))"
        cell.moneyLabel.textColor = .white
        cell.layer.cornerRadius = 30
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    //Tamaño de cada celda
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width-10  // ancho de las tarjetas
        let height = collectionView.bounds.height // alto de las tarjetas
        collectionView.isPagingEnabled = true
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20 // espacio entre celdas
    }
    
    
    //Accion ir a perfil usuario
    @IBAction func goProfile(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: sender)
        
    }    
    
    //Se oculta la navigationBar durante le proceso de viewWillAppear para que no tenga probelmas con el boton perfil
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
}

