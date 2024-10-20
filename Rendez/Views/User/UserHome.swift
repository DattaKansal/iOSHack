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

            TicketView()
                .tabItem {
                    Label("Tickets", systemImage: "ticket")
                }

            YouView()
                .tabItem {
                    Label("You", systemImage: "person")
                }
        }
        .accentColor(Color.primaryBackground)
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color.secondary)
        }
    }
}

#Preview {
    UserHome()
}
