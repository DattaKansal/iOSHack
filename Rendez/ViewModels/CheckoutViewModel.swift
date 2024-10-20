//
//  CheckoutViewModel.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/20/24.
//


//
//  CheckoutViewModel.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/20/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI


class CheckoutViewModel: ObservableObject {
    var userID: String = ""
    var user: User?
    var ticketsRefs: [String: [DocumentReference]] = [:]

    @Published var eventTier: String = ""
    @Published var event: Event?

    private let db = Firestore.firestore()

    func createTicket(eventTier: String, event: Event) async {
        getCurrentUser()

        let ticketDict: [String: Any] = [
            "tier": self.eventTier
        ]
        let doc = db.collection("TICKETS").addDocument(data: ticketDict) {error in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
        }
        doc.updateData(["ticketID" : doc.documentID]) {error in
            if let error = error {
                print("Error updating document: \(error)")
                return
            }
        }
        doc.updateData(["tier" : eventTier]) {error in
            if let error = error {
                print("Error updating document: \(error)")
                return
            }
        }
        var attendees: [String] = []
        let eventDoc = db.collection("EVENTS").document(event.docID)
        eventDoc.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                return
            }
            var attendees = document.data()?["attendees"] as? [String] ?? []
            if !attendees.contains(self.userID) {
                attendees.append(self.userID)
                
                eventDoc.updateData(["attendees": attendees]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        }
//        let userDoc = db.collection("USERS").document(userID)
//            userDoc.getDocument() { (document, error) in
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
//
//
//                let data = document.data()
//                self.ticketsRefs = data?["events"] as? [String:[DocumentReference]] ?? [:]
//                let documentID = self.event?.docID ?? ""
//                if self.ticketsRefs[documentID] == nil {
//                    self.ticketsRefs[documentID] = []  // Add a new empty array if documentID doesn't exist
//                }
//                self.ticketsRefs[documentID]?.append(doc)
//                userDoc.updateData(["events" : self.ticketsRefs])
//            }

    }

    func getCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.userID = user.uid
        } else {
            print("No user is signed in.")
            self.userID = "No user signed in"
        }
    }
}
