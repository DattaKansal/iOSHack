//
//  HostEventsView.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI

struct HostEventsView: View {
    @StateObject private var viewModel = HostEventViewModel()
    @State var events: [Event]? = nil
    @State private var hostHome: Bool = false
    @State private var showAddEventView: Bool = false // To trigger navigation to Add Event view
    @State private var isActive: Bool = false

    var body: some View {
        NavigationStack {
            NavigationLink(destination: HostHome(), isActive: $hostHome) {}
            VStack {
                Spacer()
                HStack {
                    Text("Your Events")
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
            .toolbar {
                // Add "+" button in the top-right corner
                if isActive {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddEventView = true // Trigger navigation
                        }) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .onAppear {
                isActive = true // Set the toolbar state to active
            }
            .onDisappear {
                isActive = false // Clear the toolbar state when navigating away
            }
            .navigationDestination(isPresented: $showAddEventView) {
                CreateEventView()
            }
        }
    }

    // Function to fetch events
    private func fetchEvents() async {
        do {
            let fetchedEvents = try await viewModel.getHostEvents()
            events = fetchedEvents
        } catch {
            print("Failed to fetch events: \(error)")
            events = []  // Handle errors or provide a fallback
        }
    }
}

#Preview {
    HostEventsView()
}
