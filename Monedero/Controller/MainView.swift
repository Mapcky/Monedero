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
    
    
    
    private var usdConversions : ConversionResult?
    private var myCotizations : [Cotization] = []

    
    
    //Outlets
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var footerImage: UIImageView!
    
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
            self?.getCotizations{[weak self] in
                self?.money()}
        }
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
                destino.email = email
                destino.wallet = wallet!
                destino.myCotizations = myCotizations
            }
        }
        if let destino = segue.destination as? LoginViewController, let buttonPressed = sender as? UIButton {
            if buttonPressed.tag == 0{
                destino.navigationItem.hidesBackButton = true
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
    
    

    @IBAction func logOut(_ sender: Any) {
        performSegue(withIdentifier: "logOut", sender: sender)
    }
    
    
    
    
    
    func getCotizations(completion: @escaping () -> Void) {
        // La URL de la API
        let apiURL = "https://api.cambio.today/v1/full/USD/"
        
        let apiKey = "json?key=50424|vdmb2r6s1mLyfwZra067"
        
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
                
                // Llamar a la clausura de finalización después de que se hayan procesado los datos
                completion()
            } catch {
                print("Error al decodificar el JSON:", error)
            }
        }

        task.resume()
    }
    
   
    func money() {
        if let conv = usdConversions?.result.conversion{
            
            if let wall = wallet?.myMoney {
                for con in conv {
                    if wall.contains(where: { whale in
                        return whale.country.rawValue == con.to
                    }) {
                        myCotizations.append(Cotization(value: Float(1 / con.rate), country: con.to))
                    }
                }
            }
        }
        myCotizations.append(Cotization(value: 1, country: "USD"))
    }
    
    
    
}
    

