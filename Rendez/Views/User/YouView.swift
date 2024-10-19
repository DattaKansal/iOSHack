//
//  TicketView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI

struct YouView: View {
    @StateObject private var viewModel = UserViewModel()
    @State var events: [Event]? = nil
    var body: some View {
        NavigationStack{
//            NavigationLink(destination: UserHome(), isActive: $userHome) {}
            VStack {
                Spacer()
                HStack {
                    Text("Past Tickets")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(.leading, 25)

                ZStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(events ?? []) { event in
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
            .onAppear {
                Task {
                    await fetchEvents() // Fetch events asynchronously on appearance
                }
            }
        }
    }

    // Function to fetch events
    private func fetchEvents() async {
        do {
            let fetchedEvents = try await viewModel.getPastTickets()  // Fetch events from the ViewModel
            events = fetchedEvents
        } catch {
            print("Failed to fetch events: \(error)")
            events = []  // Handle errors or provide a fallback
        }
    }
}

#Preview {
    YouView()
}

