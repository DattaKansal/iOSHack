//
//  EventsViewModel.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = [
        Event(title: "Dandiya Night", description: "Embrace your Indian Culture", price: 45.00, orgName: "India Club", address: "Exhibition hall", date: "Nov 4 8-10 pm", imageName: "dandiya", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)], docID: "dandiya"),
        Event(title: "Spookyween", description: "A freight for the ages", price: 35.00, orgName: "Halloween club", address: "White House", date: "Oct 31 10 pm - Nov 1 3 am", imageName: "halloween", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)], docID: "halloween"),
        Event(title: "Robot Speaker Event", description: "Learn and play with some robots", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)], docID: "robot")
    ]
}
