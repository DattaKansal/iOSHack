//
//  TicketDetailView.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/19/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct TicketDetailView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var event: Event
    var tickets: [Ticket]
    @StateObject var viewModel = QRVM()

    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(tickets ?? []) { ticket in
                        NavigationLink(destination: TicketDetailView(event: event)) {
                            TicketCard(event: event)
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
        Image(uiImage: generateQRCode(from: "hi"))
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct TicketCard: View {
    var body: some View {

    }
}



#Preview {
    TicketDetailView(event: Event(title: "Robot Speaker Event", description: "Have Fun Learning and playing with some robots sponsored by Suraj Mehrotra and his family.", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)]))
}
