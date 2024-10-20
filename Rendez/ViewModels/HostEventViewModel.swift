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
    @Published var loc: String = ""
    @Published var totalTickets: Int = 100
    @Published var pricePerTicket: Double = 50.0
    @Published var isWaitlistEnabled: Bool = false
    @Published var maxTicketsPerPerson: Int = 5
    @Published var tiers: [Tier] = [Tier(name: "", price: 50.0, numTickets: 50)]
    @Published var selectedImage: UIImage? = nil

    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var imageItem: PhotosPickerItem?
    @Published var docID: String? = ""



    var host: Host?
    @Published var hostEvents: [Event] = []

    var hostID: String = ""
    var eventsRefs: [DocumentReference] = []
    var orgName: String = ""

    private let db = Firestore.firestore()

    func createEvent() async {
        getCurrentHost()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm a"

        
        let eventDict: [String: Any] = [
            "title": self.eventName,
            "description": self.eventDescription,
            "price": self.pricePerTicket,
            "orgName": self.orgName,
            "address": self.loc,
            "start_date_time": formatter.string(from: self.startDate),
            "end_date_time": formatter.string(from: self.endDate),
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
        doc.updateData(["docID" : doc.documentID]) {error in
            if let error = error {
                print("Error updating document: \(error)")
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
                doc.updateData(["orgName" : data?["name"]]) {error in
                    if let error = error {
                        print("Error updating document: \(error)")
                        return
                    }
                }
                self.eventsRefs = data?["events"] as? [DocumentReference] ?? []
                self.eventsRefs.append(doc)
                hostDoc.updateData(["events" : self.eventsRefs])
            }

    }

    func getCurrentHost() {
        if let host = Auth.auth().currentUser {
            self.hostID = host.uid
        } else {
            print("No user is signed in.")
            self.hostID = "No user signed in"
        }
    }

    func getHostEvents() async throws -> [Event] {
        getCurrentHost()

        db.collection("HOSTS").document(hostID).getDocument() { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }

            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }

            let data = document.data()
            self.orgName = data?["name"] as? String ?? ""
        }


        let db = Firestore.firestore()
        let eventsRef = db.collection("EVENTS")

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm a"

        let query = eventsRef.whereField(
            "start_date_time",
            isGreaterThanOrEqualTo: dateFormatter.string(from: currentDate))

        let snapshot = try await query.getDocuments()

        let events = snapshot.documents.compactMap { document -> Event? in
            let docID = document.documentID
            let docData = document.data()
            let startDateTimeString =
                docData["start_date_time"] as? String ?? ""
            let attendees = docData["attendees"] as? [String] ?? []
            let description = docData["description"] as? String ?? ""
            let price = docData["price"] as? Double ?? 0.0
            let title = docData["title"] as? String ?? ""
            let address = docData["address"] as? String ?? ""
            let orgName = docData["orgName"] as? String ?? ""
            let imageName = docData["imageName"] as? String ?? ""
            let endDateTimeString = docData["end_date_time"] as? String ?? ""
            let isWaitlistEnabled = docData["isWaitlistEnabled"] as? Bool ?? false
            let maxTicketsPerPerson = docData["maxTicketsPerPerson"] as? Int ?? 0
            guard orgName == self.orgName else {
                return nil
            }


            // Parse the start_date_time
            guard let startDateTime = dateFormatter.date(
                    from: startDateTimeString)
            else {
                return nil
            }

            // Check if the start_date_time is before the current date
            guard startDateTime < currentDate else {
                return nil
            }
            return Event(title: title, description: description, price: price,
                orgName: orgName, address: address, startDate: startDateTimeString, endDate: endDateTimeString,
                         imageName: imageName, tiers: [], docID: docID, isWaitlistEnabled: isWaitlistEnabled, maxTicketsPerPerson: maxTicketsPerPerson)
        }
        return events

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
