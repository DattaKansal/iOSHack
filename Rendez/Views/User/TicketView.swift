//
//  TicketView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI

struct TicketView: View {
    @StateObject private var viewModel = EventsViewModel()
    var body: some View {
        NavigationStack{
//            NavigationLink(destination: UserHome(), isActive: $userHome) {}
            VStack {
                Spacer()
                HStack {
                    Text("Tickets")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(.leading, 25)
                
                ZStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.events) { event in
                                NavigationLink(destination: EventDetailView(event: event)) {
                                    EventCard(event: event)
                                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
                                }
                            }
                        }
                        Spacer()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 25)
                    .frame(height: 550)
                    .scrollIndicators(.hidden)
                    
                }
                Spacer()
            }
            .background(Color.primaryBackground)
        }
    }
}

#Preview {
    TicketView()
}

