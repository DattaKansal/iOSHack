//
//  HostHome.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI

struct HostHome: View {

    var body: some View {
        NavigationStack {
            TabView {
                HostEventsView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .toolbarBackground(Color.secondary, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)

//                TicketView()
//                    .tabItem {
//                        Label("Tickets", systemImage: "ticket")
//                    }
//                    .toolbarBackground(Color.secondary, for: .tabBar)
//                    .toolbarBackground(.visible, for: .tabBar)

                HostYouView()
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
    HostHome()
}
