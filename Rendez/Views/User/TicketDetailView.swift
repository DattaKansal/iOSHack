//
//  TicketDetailView.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/19/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins



struct TicketDetailView: View {
    var event: Event
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var tickets: [Ticket]? = nil
    @StateObject var viewModel = QRVM()
    @State private var userHome: Bool = false

    var body: some View {
        NavigationStack {
            NavigationLink(destination: UserHome(), isActive: $userHome) {}
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        Text("Your Tickets")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding(.leading, 25)

                    ZStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 15) {
                                ForEach(tickets ?? []) { ticket in
                                    TicketCard(ticket: ticket, event: event)
                                        .shadow(color: Color.black.opacity(0.6), radius: 10, x: 0, y: 10)

                                }
                            }
                            Spacer()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .safeAreaPadding(.horizontal, 25)
                        .frame(height: 430)
                        .scrollIndicators(.hidden)

                    }
                    VStack(alignment: .leading) {
                        Text(self.event.title)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)


                        Label(self.event.date, systemImage: "calendar")
                            .foregroundColor(.secondary)
                        Label("\(self.event.address)", systemImage: "location")
                            .foregroundColor(.secondary)

                        Divider()
                            .background(Color.secondary)
                            .padding(.trailing, 25)

                        Text("Announcements")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                    }
                    .padding(.leading, 25)
                    Spacer()
                }
                .background(Color.primaryBackground)
                .onAppear {
                    Task {
                        await fetchTickets() // Fetch events asynchronously on appearance
                    }
                }
            }
            .background(Color.primaryBackground)

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.userHome = true;
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.primary)
                        .bold()
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }
    
    private func fetchTickets() async {
        do {
            let fetchedTickets = try await viewModel.getTickets(event: self.event)  // Fetch events from the ViewModel
            self.tickets = fetchedTickets
        } catch {
            print("Failed to fetch events: \(error)")
            self.tickets = []  // Handle errors or provide a fallback
        }
    }
}





struct TicketCard: View {
    @State var ticket: Ticket
    var event: Event
    @StateObject var viewModel = QRVM()
    var body: some View {
        ZStack {

            Image(self.event.imageName)
                .resizable()
                .frame(width: 350, height: 400)
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(20)
                .overlay(
                    // Create a gradient to darken the bottom part
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(1)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 400), // Adjust height based on how much of the image you want to darken
                    alignment: .bottom
                )
            Image(uiImage: viewModel.generateQRCode(from: ("\(ticket.id)")))
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .cornerRadius(15)
            HStack {
                VStack(alignment: .center) {
                    Spacer()
                    Label("\(self.ticket.tier)", systemImage: "ticket")
                        .foregroundColor(.secondary)
                }
                .padding(20)
            }
        }
        .background(Color.secondBackground)
        .frame(width: 350, height: 400)
        .cornerRadius(20)
    }
}



#Preview {
    TicketDetailView(event: Event(title: "Robot Speaker Event", description: "Have Fun Learning and playing with some robots sponsored by Suraj Mehrotra and his family.", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)], docID: "dandiya"))
}
