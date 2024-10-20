//
//  EventView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI
struct EventView: View {
    @StateObject private var viewModel = UserViewModel()
    @State var events: [Event]? = nil
    @State private var userHome: Bool = false
    @State private var isGridView: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 60) //
                HStack {
                    Text("Events")
                        .font(.system(size: 34))
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        isGridView.toggle()
                    }) {
                        Image(systemName: isGridView ? "rectangle.grid.1x2" : "square.grid.2x2")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20) 
                
                if isGridView {
                    EventGridView(events: events ?? [])
                } else {
                    EventScrollView(events: events ?? [])
                }
            }
            .background(Color.primaryBackground)
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            Task {
                await fetchEvents()
            }
        }
    }

    private func fetchEvents() async {
        do {
            let fetchedEvents = try await viewModel.getEvents()
            events = fetchedEvents
        } catch {
            print("Failed to fetch events: \(error)")
            events = []
        }
    }
}

#Preview {
    EventView()
}
