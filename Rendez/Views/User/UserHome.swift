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
        NavigationView {
            ZStack {
                Color.primaryBackground.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(viewModel.events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCard(event: event)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Events")
        }
    }
}


#Preview {
    UserHome()
}
