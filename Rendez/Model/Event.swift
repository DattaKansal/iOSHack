//
//  Event.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import Foundation

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let price: Double
    let orgName: String
// let orgImage : String
//    let distance: Double
    let address: String
    let date: String
    let imageName: String
    let tiers: [Tier?]
    
// let numAttendees: Int

    var totalTickets: Int
 //   var pricePerTicket: Double
    var isWaitlistEnabled: Bool
    var waitlistOpenAfterSoldOut: Int
    var maxTicketsPerPerson: Int
    var tieredPricing: Bool
 //   var selectedImage: UIImage?
    
}
