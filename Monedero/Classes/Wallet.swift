//
//  Wallet.swift
//  Monedero
//
//  Created by Mateo Andres Perano on 04/04/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class Wallet :Codable {
    
    @DocumentID var id : String?
    var myMoney : [Currency]
    
    init(money :[Currency]) {
        self.myMoney = money
    }
    
}
