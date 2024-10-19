//
//  EventDetailView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var tierCounts: [UUID: Int] = [:]
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top image
                    Image(event.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Title and organization name
                        VStack(alignment: .leading, spacing: 5) {
                            Text(event.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(event.orgName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .bold()
                        }
                        Divider()
                            .background(Color.secondary)
                        // Description
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.primary)

                        Divider()
                            .background(Color.secondary)

                        // Address and timings
                        HStack {
                            Image(systemName: "location")
                            Text(event.address)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "calendar")
                            Text(event.date)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        Divider()
                            .background(Color.secondary)

                        // Tiers list
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ticket Tiers")
                                .font(.headline)
                                .foregroundColor(.white)

                            ForEach(event.tiers.compactMap { $0 }) { tier in
                                TierView(tier: tier, count: tierCounts[tier.id] ?? 0) { newCount in
                                    tierCounts[tier.id] = newCount
                                }
                            }
                        }
                        
                        // Book tickets button
                        Button(action: {
                            // Add booking functionality
                        }) {
                            Text("Book Tickets")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primary)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                        .padding(.top)
                        .disabled(tierCounts.values.reduce(0, +) == 0)
                        Spacer()
                    }
                    .padding()
                }
            }
            .edgesIgnoringSafeArea(.top)
            .background(Color.primaryBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    EventDetailView(event: Event(title: "Robot Speaker Event", description: "Have Fun Learning and playing with some robots sponsored by Suraj Mehrotra and his family.", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)]))
}


