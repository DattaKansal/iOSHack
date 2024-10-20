//
//  UserViewModel.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var name: String = ""
    var userID: String = ""
    private let db = Firestore.firestore()

    func getEvents() async throws -> [Event] {
        getCurrentUser()
        let db = Firestore.firestore()
        let eventsRef = db.collection("EVENTS")
        print("Hello")
        
        // Get current date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm a"

        // Query events where start_date_time is greater than or equal to current date
        let query = eventsRef.whereField(
            "start_date_time",
            isGreaterThanOrEqualTo: dateFormatter.string(from: currentDate)
        )

        let snapshot = try await query.getDocuments()

        var events: [Event] = []

        for document in snapshot.documents {
            let docID = document.documentID
            let docData = document.data()
            let startDateTimeString = docData["start_date_time"] as? String ?? ""
            let attendees = docData["attendees"] as? [String] ?? []
            let description = docData["description"] as? String ?? ""
            let price = docData["price"] as? Double ?? 0.0
            let title = docData["title"] as? String ?? ""
            let address = docData["address"] as? String ?? ""
            let orgName = docData["orgName"] as? String ?? ""
            let imageName = docData["imageName"] as? String ?? ""
            let endDateTimeString = docData["end_date_time"] as? String ?? ""
            let totalTickets = docData["totalTickets"] as? Int ?? 0
            let isWaitlistEnabled = docData["isWaitlistEnabled"] as? Bool ?? false
            let waitlistOpenAfterSoldOut = docData["waitlistOpenAfterSoldOut"] as? Int ?? 0
            let maxTicketsPerPerson = docData["maxTicketsPerPerson"] as? Int ?? 0
            
            guard !attendees.contains(userID) else {
                continue
            }

            // Parse the start_date_time
            guard let startDateTime = dateFormatter.date(from: startDateTimeString) else {
                continue
            }

            // Check if the start_date_time is before the current date
            guard startDateTime < currentDate else {
                continue
            }

            // Fetch the TIERS subcollection
            let tiersRef = db.collection("EVENTS").document(docID).collection("TIERS")
            let tiersSnapshot = try await tiersRef.getDocuments()

            let tiers: [Tier] = tiersSnapshot.documents.compactMap { tierDoc in
                let tierData = tierDoc.data()
                let name = tierData["name"] as? String ?? ""
                let numTickets = tierData["numTickets"] as? Int ?? 0
                let price = tierData["price"] as? Double ?? 0.0
                return Tier(name: name, price: price, numTickets: numTickets)
            }

            let event = Event(
                title: title,
                description: description,
                price: price,
                orgName: orgName,
                address: address,
                date: startDateTimeString,
                imageName: imageName,
                tiers: tiers,
                docID: docID,
                totalTickets: totalTickets,
                isWaitlistEnabled: isWaitlistEnabled,
                waitlistOpenAfterSoldOut: waitlistOpenAfterSoldOut,
                maxTicketsPerPerson: maxTicketsPerPerson
            )

            events.append(event)
        }

        return events
    }


    func getCurrentTickets() async throws -> [Event] {
        getCurrentUser()
        let db = Firestore.firestore()
        let eventsRef = db.collection("EVENTS")
        print("Hello")
        // Get current date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm a"

        // Query events where start_date_time is less than or equal to current date
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
            let totalTickets = docData["totalTickets"] as? Int ?? 0
            let isWaitlistEnabled = docData["isWaitlistEnabled"] as? Bool ?? false
            let waitlistOpenAfterSoldOut = docData["waitlistOpenAfterSoldOut"] as? Int ?? 0
            let maxTicketsPerPerson = docData["maxTicketsPerPerson"] as? Int ?? 0
            let tieredPricing = docData["tieredPricing"] as? Bool ?? false
            guard attendees.contains(userID) else {
                return nil
            }

            // Parse the start_date_time
            guard
                let startDateTime = dateFormatter.date(
                    from: startDateTimeString)
            else {
                return nil
            }

            // Check if the start_date_time is before the current date
            guard startDateTime <= currentDate else {
                return nil
            }
            return Event(title: title, description: description, price: price,
                orgName: orgName, address: address, date: startDateTimeString,
                         imageName: imageName, tiers: [], docID: docID, totalTickets: totalTickets, isWaitlistEnabled: isWaitlistEnabled, waitlistOpenAfterSoldOut: waitlistOpenAfterSoldOut, maxTicketsPerPerson: maxTicketsPerPerson)
        }
        return events
    }

    func getPastTickets() async throws -> [Event] {
        getCurrentUser()
        let db = Firestore.firestore()
        let eventsRef = db.collection("EVENTS")
        print("Hello")
        // Get current date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm a"

        // Query events where start_date_time is less than or equal to current date
        let query = eventsRef.whereField(
            "start_date_time",
            isLessThan: dateFormatter.string(from: currentDate))

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
            let totalTickets = docData["totalTickets"] as? Int ?? 0
            let isWaitlistEnabled = docData["isWaitlistEnabled"] as? Bool ?? false
            let waitlistOpenAfterSoldOut = docData["waitlistOpenAfterSoldOut"] as? Int ?? 0
            let maxTicketsPerPerson = docData["maxTicketsPerPerson"] as? Int ?? 0
            let tieredPricing = docData["tieredPricing"] as? Bool ?? false
            guard attendees.contains(userID) else {
                return nil
            }

            // Parse the start_date_time
            guard
                let startDateTime = dateFormatter.date(
                    from: startDateTimeString)
            else {
                return nil
            }

            // Check if the start_date_time is before the current date
            guard startDateTime < currentDate else {
                return nil
            }
            return Event(title: title, description: description, price: price,
                orgName: orgName, address: address, date: startDateTimeString,
                         imageName: imageName, tiers: [], docID: docID, totalTickets: totalTickets, isWaitlistEnabled: isWaitlistEnabled, waitlistOpenAfterSoldOut: waitlistOpenAfterSoldOut, maxTicketsPerPerson: maxTicketsPerPerson)
        }
        return events
    }

    func getCurrentUser() {
        if let user = Auth.auth().currentUser {
            // Access user properties
            self.userID = user.uid ?? "No uid"
            db.collection("USERS").document(userID).getDocument() { (document, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                }

                guard let document = document, document.exists else {
                    print("Document does not exist")
                    return
                }

                let data = document.data()
                self.name = data?["name"] as? String ?? ""
            }
        } else {
            print("No user is signed in.")
            self.userID = "No user signed in"
        }
    }
    //                else {
    //                return nil
    //            }

    // Check if the event doesn't contain the user ID in attendees

    // Create and return the Event object
    // You'll need to adjust this based on your Event struct/class definition

}
