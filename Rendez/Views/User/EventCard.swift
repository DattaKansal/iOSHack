//
//  EventCard.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//
import SwiftUI
struct EventCard: View {
    let event: Event
    
    var body: some View {
        ZStack {
            Image(event.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 400)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            VStack(alignment: .leading) {
                Spacer()
                Text(event.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                Label(event.startDate, systemImage: "calendar")
                    .foregroundColor(.white)
                Label(event.address, systemImage: "location")
                    .foregroundColor(.white)
                Label(event.price == 0 ? "Free" : "$\(String(format: "%.2f", event.price))", systemImage: "dollarsign.circle")
                    .foregroundColor(.white)
            }
            .padding(20)
        }
        .frame(width: 300, height: 400)
        .background(Color.primaryBackground)
        .cornerRadius(20)
    }
}
