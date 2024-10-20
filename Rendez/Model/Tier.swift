//
//  Tier.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import Foundation

struct Tier: Identifiable, Hashable {
    let id = UUID()
    var name : String
    var price : Double
    var numTickets : Int
}
