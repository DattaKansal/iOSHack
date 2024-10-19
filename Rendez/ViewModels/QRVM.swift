//
//  QRVM.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/19/24.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins


class QRVM: ObservableObject {
    @Published var user: User?
    var userID: String = ""
    var eventID: String = ""
    var event: Event? = nil
    private let db = Firestore.firestore()

    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }

    func getTickets(event: Event?) async throws -> [Ticket] {
            return try await withCheckedThrowingContinuation { continuation in
                getCurrentUser()

                let docRef = db.collection("USERS").document(userID)

                docRef.getDocument { document, error in
                    if let error = error {
                        print("Error fetching document: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let data = document?.data(),
                          let events = data["events"] as? [String: Any] else {
                        continuation.resume(returning: []) // Return an empty array if no events found
                        return
                    }

                    // Safely unwrap eventID
                    guard let eventID = event?.docID else {
                        continuation.resume(returning: []) // Return an empty array if eventID is nil
                        return
                    }

                    // Access the ticket references for the given eventID
                    if let ticketRefs = events[eventID] as? [DocumentReference] { // Assuming ticket references are stored as strings
                        var tickets: [Ticket] = []
                        let group = DispatchGroup() // Group to wait for all ticket fetches
                        // Loop through the ticketRefs array
                        for ticketRefID in ticketRefs {
                            group.enter() // Enter the dispatch group for each ticket fetch

                            // Fetch each ticket document from Firestore
                            ticketRefID.getDocument { ticketDocument, error in
                                if let error = error {
                                    print("Error fetching ticket document: \(error.localizedDescription)")
                                } else if let ticketData = ticketDocument?.data() {
                                    // Assuming Ticket is initialized from a dictionary
                                    let tier = ticketData["tier"] as? String ?? ""
                                    let ticket = Ticket(tier: tier)
                                    tickets.append(ticket)
                                }

                                group.leave() // Leave the dispatch group once the fetch is done
                            }
                        }

                        // Notify when all ticket fetches are complete
                        group.notify(queue: .main) {
                            continuation.resume(returning: tickets) // Resume with the tickets
                        }
                    } else {
                        // If no matching event found, return an empty array
                        continuation.resume(returning: [])
                    }
                }
            }
        }


    func getCurrentUser() {
        if let user = Auth.auth().currentUser {
            self.userID = user.uid ?? "No uid"
        } else {
            print("No user is signed in.")
            self.userID = "No user signed in"
        }
    }

}


