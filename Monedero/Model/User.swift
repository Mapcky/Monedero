//
//  Wallet.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 04/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class User :Codable {
    
    @DocumentID var id : String?
    let email : String
    var name: String
    var wallet : [Currency]
    
    init(id: String? = nil, email: String, name: String, wallet: [Currency]) {
        self.id = id
        self.email = email
        self.name = name
        self.wallet = wallet
    }

}
