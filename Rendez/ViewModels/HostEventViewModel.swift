//
//  HostEventViewModel.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI

class HostEventViewModel: ObservableObject {
    @Published var eventName: String = ""
    @Published var eventDescription: String = ""
    @Published var eventDate = Date()
    @Published var location: String = ""
    @Published var totalTickets: Int = 100
    @Published var pricePerTicket: Double = 50.0
    @Published var isWaitlistEnabled: Bool = false
    @Published var waitlistOpenAfterSoldOut: Int = 10
    @Published var maxTicketsPerPerson: Int = 5
    @Published var tieredPricing: Bool = false
    @Published var tiers: [Tier] = [Tier(name: "", price: 50.0, numTickets: 50)]
    @Published var selectedImage: UIImage? = nil
    @Published var hostModel = HostViewModel()
    
    var totalTicketsInput: String = "100"
    
    func createEvent() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        hostModel.createHostEvent(event: Event(
            title: eventName,
            description: eventDescription,
            price: pricePerTicket,
            orgName: "",
            address: location,
            date: formatter.string(from: eventDate),
            imageName: "",
            tiers: tiers,
            totalTickets: totalTickets,
            isWaitlistEnabled: isWaitlistEnabled,
            waitlistOpenAfterSoldOut: waitlistOpenAfterSoldOut,
            maxTicketsPerPerson: maxTicketsPerPerson,
            tieredPricing: tieredPricing
        ))
    }
    
    func updateTotalTickets() {
        if let value = Int(totalTicketsInput) {
            totalTickets = value
        } else {
            totalTickets = 0
        }
    }
    
//    func adjustTiers(numberOfTiers: Int) {
//        if numberOfTiers > tiers.count {
//            let additionalTiers = numberOfTiers - tiers.count
//            tiers.append(contentsOf: Array(repeating: Tier(name: "", price: 50.0, numTickets: 50), count: additionalTiers))
//        } else if numberOfTiers < tiers.count {
//            tiers.removeLast(tiers.count - numberOfTiers)
//        }
//    }
}
