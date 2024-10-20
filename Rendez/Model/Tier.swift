//
//  Tier.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import Foundation

struct Tier: Identifiable, Hashable {
    let id: UUID
    var name: String
    var price: Double
    var numTickets: Int
    
    init(id: UUID = UUID(), name: String, price: Double, numTickets: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.numTickets = numTickets
    }
}
