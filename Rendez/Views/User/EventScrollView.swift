//
//  EventListView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/20/24.
//

import SwiftUI

struct EventScrollView: View {
    let events: [Event]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(events) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            EventCard(event: event)
                                .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: .infinity)
    }
}
