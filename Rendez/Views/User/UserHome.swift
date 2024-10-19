//
//  UserHome.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct UserHome: View {

    var body: some View {
        NavigationStack {
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

            }
            .tint(Color.primaryBackground)

        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    UserHome()
}
