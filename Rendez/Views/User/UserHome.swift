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

            YouView()
                .tabItem {
                    Label("You", systemImage: "person")
                }
                .toolbarBackground(Color.secondary, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackgroundVisibility(.visible, for: .tabBar)
        }
        .tint(Color.primaryBackground)
    }
}

#Preview {
    UserHome()
}
