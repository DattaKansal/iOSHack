//
//  Tier.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import Foundation

struct Tier: Identifiable {
    let id = UUID()
    let name : String
    let price : Double
    let numTickets : Int
}
