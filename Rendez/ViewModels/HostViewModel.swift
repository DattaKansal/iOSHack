//
//  HostViewModel.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import FirebaseFirestore
import SwiftUI

class HostViewModel: ObservableObject {
    @Published var host: Host?
    
    private let db = Firestore.firestore()
    
    func fetchHost(hostID: String) {
        let docRef = db.collection("Hosts").document(hostID)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let email = data?["email"] as? String ?? ""
                let username = data?["username"] as? String ?? ""
                self?.host = Host(id: hostID, email: email, username: username)
            }
        }
    }
    
    func createHostEvent(event: Event) {
        print("called")
        guard let hostID = host?.id else { return }
        
        let eventDict: [String: Any] = [
            "title": event.title,
            "description": event.description,
            "price": event.price,
            "orgName": event.orgName,
            "address": event.address,
            "date": event.date,
            "imageName": event.imageName,
            "tiers": event.tiers.map { tier in
                return [
                    "name": tier?.name ?? "",
                    "price": tier?.price ?? 0.0,
                    "numTickets": tier?.numTickets ?? 0
                ]
            }
        ]
        
        db.collection("Hosts").document(hostID).updateData([
            "events": FieldValue.arrayUnion([eventDict])
        ]) { error in
            if let error = error {
                print("Error adding event: \(error)")
            } else {
                print("Event successfully added!")
            }
        }
    }
}
