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
    
    //Outlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tradeB: UIButton!
    @IBOutlet weak var depositB: UIButton!
    
    //Variables
    private var user :User?
    var email: String?
    private var usdConversions : ConversionResult?
    private var myCotizations : [Cotization] = []
    private let enumCountries = Country.allCases

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
            FirebaseManager.shared.getUserData(email: email) {usr, error in
                if let error = error {
                    print("Error fetching resources: \(error)")
                    return
                }
                // Una vez que los datos se hayan cargado, actualiza la vista
                if let user = usr {
                    self.user = usr
                    self.loading.stopAnimating()
                    self.loading.isHidden = true
                    self.collectionView.reloadData()
                    self.profileButton.setTitle("Hola \(user.name)", for: .normal)
                    self.profileButton.isHidden = false
                    self.tradeB.isHidden = false
                    self.depositB.isHidden = false
                }
            }
        }
        FirebaseManager.shared.getResources{ apiURL, apiKey, error in
            if let error = error {
                print("Error fetching resources: \(error)")
                return
            }
            // Deshabilitar los botones antes de iniciar la tarea
            self.tradeB.isEnabled = false
            self.depositB.isEnabled = false
            // Desempaquetado de apiURL y apiKey
            if let apiURL = apiURL, let apiKey = apiKey {
                self.getCotizations(apiURL: apiURL, apiKey: apiKey) { [weak self] in
                    self?.makeCotziationsArray(apiURL: apiURL, apiKey: apiKey)
                }
            } else {
                print("Error: apiURL or apiKey is nil")
            }
        }
    }

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
                destino.user = user!
                destino.myCotizations = myCotizations
            }
        }
        if let destino = segue.destination as? DepositView, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 1{
                destino.user = user!
            }
        }
        if let destino = segue.destination as? ProfileViewController, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 2{
                destino.name = user?.name
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    //Creacion de numero de tarjetas, segun cuantos items pertenezcan a el array de Currency
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if let user = user {
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
        let activeCurrencies = user?.wallet.filter { $0.isActive == true }
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
    
    // MARK: - getCotizations
    //Obtiene el JSON de la API y lo decodifica
    func getCotizations(apiURL:String, apiKey:String, completion: @escaping () -> Void) {
        // La URL de la API
        let apiURLString = apiURL + apiKey

        // Crear la URL a partir de la cadena
        guard let url = URL(string: apiURLString) else {
            print("URL inválida")
            return
        }
        // Crear una tarea de URLSession para obtener los datos JSON
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Manejar cualquier error
            if let error = error {
                print("Error al obtener datos:", error)
                return
            }
            // Verificar si los datos existen
            guard let jsonData = data else {
                print("Datos no encontrados")
                return
            }
            do {
                // Decodificar los datos JSON en la estructura definida
                self.usdConversions = try JSONDecoder().decode(ConversionResult.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.tradeB.isEnabled = true
                    self.depositB.isEnabled = true
                }
                
                // Llamar a la clausura de finalización después de que se hayan procesado los datos
                completion()
            } catch {
                print("Error al decodificar el JSON:", error)
            }
        }
        task.resume()
    }
    
    //MARK: - money
   //Obtiene las cotizaciones necesarias segun los elementos existentes en el enum Country
    func makeCotziationsArray(apiURL:String , apiKey:String) {
        if let conv = usdConversions?.result.conversion{
            for con in conv {
                if enumCountries.contains(where: { whale in
                    //Caso particular, buscar otra solucion
                    return whale.rawValue.contains(con.to) && con.to != "AR"
                }) {
                    myCotizations.append(Cotization(value: Float(1 / con.rate), country: con.to))
                    print(myCotizations.last!.country)
                }
            }
        }
//        myCotizations.append(Cotization(value: 1, country: "USD"))
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

