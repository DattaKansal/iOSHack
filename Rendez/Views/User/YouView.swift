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
    @State private var userSettings: Bool = false
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                        .ignoresSafeArea()
                        .frame(height: 250)
                    VStack {
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                        Text(viewModel.name)
                            .bold()
                            .font(.title2)
                    }
                    .padding()

                }
                Spacer()
                HStack {
                    Text("Past Tickets")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(25)

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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.userSettings = true;
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color.primaryBackground)
                            .bold()
                            .font(.title2)
                    }
                }
            }
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

