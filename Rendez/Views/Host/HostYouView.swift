//
//  HostYouView.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI

struct HostYouView: View {
    @StateObject private var viewModel = HostEventViewModel()
    @State var events: [Event]? = nil
    @State private var userSettings: Bool = false
    @State private var isActive: Bool = false
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                        .ignoresSafeArea()
                        .frame(height: 255)
                    VStack {
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                        Text("Hey, " + (viewModel.host?.username ?? "Host"))
                            .bold()
                            .font(.title2)
                    }
                    .padding()

                }
                Spacer()
                HStack {
                    Text("Hosted Events")
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
                                EventCard(event: event)
                                    .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
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
                if isActive {
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
            }
            .onAppear {
                isActive = true
                Task {
                    await fetchEvents() // Fetch events asynchronously on appearance
                }
            }
            .onDisappear {
                isActive = false // Clear the toolbar state when navigating away
            }
        }
    }

    // Function to fetch events
    private func fetchEvents() async {
        do {
            let fetchedEvents = viewModel.host?.events  // Fetch events from the ViewModel
            events = fetchedEvents
        }
    }
}

#Preview {
    HostYouView()
}
