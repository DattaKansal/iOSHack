//
//  UserHome.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let price: Double
    let distance: Double
    let date: String
    let imageName: String
}

struct UserHome: View {
    let events = [
        Event(title: "Dandiya Night", description: "Embrace your Indian Culture", price: 45.00, distance: 5.1, date: "Nov 4-6", imageName: "dandiya"),
        Event(title: "Spookyween", description: "A freight for the ages", price: 35.00, distance: 3.2, date: "Nov 10-12", imageName: "halloween"),
        Event(title: "Robot Speaker event", description: "Learn and play with some robots", price: 0, distance: 1.2, date: "Nov 1-3", imageName: "robot")
    ]
    
    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Events")
                    .font(.largeTitle)
                    .foregroundColor(.tertiary)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(events) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(event.imageName)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
                .cornerRadius(10)
            
            Text(event.title)
                .font(.title2)
                .foregroundColor(.primary)
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label("$\(String(format: "%.2f", event.price))", systemImage: "dollarsign.circle")
                Spacer()
                Label("\(String(format: "%.1f", event.distance)) Km", systemImage: "location")
                Spacer()
                Label(event.date, systemImage: "calendar")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.primaryBackground)
        .cornerRadius(15)
    }
}


#Preview {
    UserHome()
}
