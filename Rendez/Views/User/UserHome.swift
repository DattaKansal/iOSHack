//
//  UserHome.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct UserHome: View {
    @StateObject private var viewModel = EventsViewModel()

    var body: some View {
        TabView {
            EventView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .toolbarBackground(Color.secondary, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

            TicketView()
                .tabItem {
                    Label("Tickets", systemImage: "ticket")
                }
                .toolbarBackground(Color.secondary, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

//            ThirdView()
//                .tabItem {
//                    Label("Tickets", systemImage: "ticket")
//                }
//                .toolbarBackground(Color.secondary, for: .tabBar)
//                .toolbarBackground(.visible, for: .tabBar)
        }
        .tint(Color.primaryBackground)

    }
}

struct EventView: View {
    @StateObject private var viewModel = EventsViewModel()
    @State private var userHome: Bool = false
    var body: some View {
        NavigationStack{
            NavigationLink(destination: UserHome(), isActive: $userHome) {}
            VStack {
                Spacer()
                HStack {
                    Text("Events")
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

struct TicketView: View {
    var body: some View {
        VStack{

        }
    }
}

struct ThirdView: View {
    var body: some View {
        VStack{

        }
    }
}


#Preview {
    UserHome()
}
