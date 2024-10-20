//
//  EventGridView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/20/24.
//

import SwiftUI

struct EventGridView: View {
    let events: [Event]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventGridCard(event: event)
                    }
                }
            }
            .padding()
        }
    }
}
struct EventGridCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(event.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(10)
            
            Text(event.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(event.startDate)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(event.address)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Text(event.price == 0 ? "Free" : "$\(String(format: "%.2f", event.price))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(Color.secondary)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
