//
//  UserViewModel.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserViewModel: ObservableObject {
    @Published var user: User?
    private let db = Firestore.firestore()
    
    

    func getEvents(userID: String) async throws -> [Event] {
        let db = Firestore.firestore()
        let eventsRef = db.collection("EVENTS")
        print("Hello")
        // Get current date
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        
        // Query events where start_date_time is less than or equal to current date
        let query = eventsRef.whereField("start_date_time", isGreaterThan: dateFormatter.string(from: currentDate))
        
        let snapshot = try await query.getDocuments()
        
        let events = snapshot.documents.compactMap { document -> Event? in
            print(document.documentID)
            let docData = document.data()
        let startDateTimeString = docData["start_date_time"] as? String ?? ""
          let attendees = docData["attendees"] as? [String] ?? []
          let description = docData["description"] as? String ?? ""
            let price = docData["price"] as? Double ?? 0.0
          let title = docData["title"] as? String ?? ""
          let address = docData["address"] as? String ?? ""
          let orgName = docData["orgName"] as? String ?? ""
          let imageName = docData["image_name"] as? String ?? ""
          let endDateTimeString = docData["end_date_time"] as? String ?? ""
            
            guard !attendees.contains(userID) else {
                return nil
            }

            // Parse the start_date_time
            guard let startDateTime = dateFormatter.date(from: startDateTimeString) else {
                return nil
            }

            // Check if the start_date_time is before the current date
            guard startDateTime < currentDate else {
                return nil
            }
            return Event(title: title, description: description, price: price, orgName: orgName, address: address, date: startDateTimeString, imageName: imageName, tiers: [])
        }
//                else {
//                return nil
//            }
            
            // Check if the event doesn't contain the user ID in attendees
            
            // Create and return the Event object
            // You'll need to adjust this based on your Event struct/class definition

        
        return events
    }
  
}
