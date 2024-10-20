//
//  HostEventViewModel.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI
import _PhotosUI_SwiftUI


class HostEventViewModel: ObservableObject {
    @Published var eventName: String = ""
    @Published var eventDescription: String = ""
    @Published var eventDate = Date()
    @Published var loc: String = ""
    @Published var totalTickets: Int = 100
    @Published var pricePerTicket: Double = 50.0
    @Published var isWaitlistEnabled: Bool = false
    @Published var waitlistOpenAfterSoldOut: Int = 10
    @Published var maxTicketsPerPerson: Int = 5
    @Published var tieredPricing: Bool = false
    @Published var tiers: [Tier] = [Tier(name: "", price: 50.0, numTickets: 50)]
    @Published var selectedImage: UIImage? = nil
    @Published var docID: String = ""

    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var imageItem: PhotosPickerItem?


    @Published var host: Host?
    var hostID: String = ""
    @State var orgName: String = ""
    var eventsRefs: [DocumentReference] = []

    private let db = Firestore.firestore()

    var totalTicketsInput: String = "100"

    
    func updateTotalTickets() {
        if let value = Int(totalTicketsInput) {
            totalTickets = value
        } else {
            totalTickets = 0
        }
    }

    func createEvent() async {
        getCurrentHost()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let eventDict: [String: Any] = [
            "title": self.eventName,
            "description": self.eventDescription,
            "price": self.pricePerTicket,
            "orgName": self.orgName,
            "address": self.loc,
            "date": self.eventDate,
            "imageName": "",
            "tiers": self.tiers.map { tier in
                return [
                    "name": tier.name,
                    "price": tier.price,
                    "numTickets": tier.numTickets
                ]
            }
        ]
        let doc = db.collection("EVENTS").addDocument(data: eventDict) {error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
        }
        let hostDoc = db.collection("HOSTS").document(hostID)
            hostDoc.getDocument() { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }

                guard let document = document, document.exists else {
                    print("Document does not exist")
                    return
                }

                let data = document.data()
                self.eventsRefs = data?["events"] as? [DocumentReference] ?? []
                self.eventsRefs.append(doc)
                hostDoc.updateData(["events" : self.eventsRefs])
            }

    }

    func getCurrentHost() {
        if let host = Auth.auth().currentUser {
            self.hostID = host.uid
//            db.collection("HOSTS").document(hostID).getDocument() { (document, error) in
//                if let error = error {
//                    print("Error fetching document: \(error)")
//                    return
//                }
//
//                guard let document = document, document.exists else {
//                    print("Document does not exist")
//                    return
//                }
//
//                let data = document.data()
//                self.orgName = data?["name"] as? String ?? ""
//                self.eventsRefs = data?["events"] as? [DocumentReference] ?? []
//            }
        } else {
            print("No user is signed in.")
            self.hostID = "No user signed in"
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
