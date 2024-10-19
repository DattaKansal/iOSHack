//
//  EventDetailView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    
    var body: some View {
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
                            .foregroundColor(.secondary)
                        Text(event.orgName)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    
                    // Description
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Address and timings
                    HStack {
                        Image(systemName: "location")
                        Text(event.address)
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(event.date)
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    
                    // Tiers list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ticket Tiers")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ForEach(event.tiers.compactMap { $0 }) { tier in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(tier.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text("$\(String(format: "%.2f", tier.price))")
                                        .font(.caption)
                                }
                                Spacer()
                                Text("\(tier.numTickets) available")
                                    .font(.caption)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.secondBackground)
                            .cornerRadius(8)
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
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color.primaryBackground)
        .navigationBarTitleDisplayMode(.inline)
    }
}
