//
//  SwiftUIView.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI
import PhotosUI

struct HostEventView: View {
    @State private var eventName: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate = Date()
    @State private var location: String = ""
    @State private var totalTickets: Int = 100
    @State private var pricePerTicket: Double = 50.0
    @State private var isWaitlistEnabled: Bool = false
    @State private var waitlistOpenAfterSoldOut: Int = 10
    @State private var maxTicketsPerPerson: Int = 5
    @State private var tieredPricing: Bool = false
    @State private var tier1Price: Double = 50.0
    @State private var tier2Price: Double = 100.0
    @State private var tier1Tickets: Int = 50
    @State private var tier2Tickets: Int = 50
    
    @State private var numberOfTiers: Int = 1
    @State private var tiers: [Tier] = [Tier(name: "", price: 50.0, numTickets: 50)]
    @State private var totalTicketsInput: String = "100"
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    eventDetailsSection
                    
                    imageSection

                    ticketingSection

                    waitlistSection

                    paymentOverviewSection

                    restrictionsSection
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to Create Event
                    }) {
                        Text("Create Event")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Host Event")
        }
    }

    var eventDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Details")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(spacing: 10) {
                TextField("Event Name", text: $eventName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                TextField("Location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                DatePicker("Event Date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                    .padding(.horizontal)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                TextField("Description", text: $eventDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 100)
                    .padding(.horizontal)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .shadow(radius: 5)
        }
    }
    
    var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Image")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.orange)

            Button(action: {
                showImagePicker = true
            }) {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                } else {
                    Text("Select An Image")
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .shadow(radius: 5)
        }
    }

    var ticketingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ticketing")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            VStack(spacing: 10) {
//                Stepper("Total Tickets: \(totalTickets)", value: $totalTickets, in: 0...1000)
//                    .padding(.horizontal)
                Text("Total Tickets")
                .multilineTextAlignment(.leading)
                
                TextField("Total Tickets", text: $totalTicketsInput, onCommit: {
                    updateTotalTickets()
                })
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                HStack {
                    Text("Price Per Ticket:")
                    Spacer()
                    Text("$\(pricePerTicket, specifier: "%.2f")")
                }
                .padding(.horizontal)
                Slider(value: $pricePerTicket, in: 0...500, step: 5)
                    .accentColor(.blue)
                    .padding(.horizontal)
                
                Toggle("Enable Tiered Pricing", isOn: $tieredPricing)
                    .padding(.horizontal)
                
                if tieredPricing {
                    tieredTicketingSection
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .shadow(radius: 5)
        }
    }
    
    private func updateTotalTickets() {
            if let value = Int(totalTicketsInput) {
                totalTickets = value
            } else {
                totalTickets = 0
            }
        }

    var tieredTicketingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tier Ticketing")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Stepper("Number of Tiers: \(numberOfTiers)", value: $numberOfTiers, in: 1...5, onEditingChanged: { _ in
                adjustTiers()
            })
            .padding(.horizontal)
            
//            ForEach(tiers.indices, id: \.self) { index in
//                let tierBinding = $tiers[index]
//                
//                VStack(spacing: 10) {
//                    TextField("Tier \(index + 1) Name", text: tierBinding.name)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding(.horizontal)
//                    
//                    HStack {
//                        Text("Tier \(index + 1) Price: $\(tierBinding.price.wrappedValue, specifier: "%.2f")")
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
//                    Slider(value: tierBinding.price, in: 0...500, step: 5)
//                        .accentColor(.blue)
//                        .padding(.horizontal)
//                    
//                    Stepper("Tickets: \(tierBinding.tickets)", value: tierBinding.tickets, in: 0...totalTickets)
//                        .padding(.horizontal)
//                }
//                .padding(.vertical, 10)
//                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//                .shadow(radius: 5)
//            }
        }
    }

    func adjustTiers() {
        if numberOfTiers > tiers.count {
            let additionalTiers = numberOfTiers - tiers.count
            tiers.append(contentsOf: Array(repeating: Tier(name: "", price: 50.0, numTickets: 50), count: additionalTiers))
        } else if numberOfTiers < tiers.count {
            tiers.removeLast(tiers.count - numberOfTiers)
        }
    }

    var waitlistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable Waitlist", isOn: $isWaitlistEnabled)
                .padding(.horizontal)
            
            if isWaitlistEnabled {
                Stepper("Waitlist Opens After \(waitlistOpenAfterSoldOut) Minutes", value: $waitlistOpenAfterSoldOut, in: 1...120)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        .shadow(radius: 5)
    }

    var paymentOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment Overview")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            HStack {
                Text("Total Tickets: \(totalTickets)")
                Spacer()
                Text("Price Per Ticket: $\(pricePerTicket, specifier: "%.2f")")
            }
            .padding(.horizontal)
            
            if tieredPricing {
                ForEach(tiers) { tier in
                    HStack {
                        Text("\(tier.name): $\(tier.price, specifier: "%.2f")")
                        Spacer()
                        Text("Tickets: \(tier.numTickets)")
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        .shadow(radius: 5)
    }


    var restrictionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Restrictions")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            Stepper("Max Tickets Per Person: \(maxTicketsPerPerson)", value: $maxTicketsPerPerson, in: 1...15)
                .padding(.horizontal)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        .shadow(radius: 5)
    }
}

struct ImagePicker: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .padding()
            } else {
                Text("Select an Image")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            PhotosPicker(selection: $selectedItem) {
                Text("Choose Photo")
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let newItem = newItem {
                        let data = try? await newItem.loadTransferable(type: Data.self)
                        if let data = data, let image = UIImage(data: data) {
                            selectedImage = image
                        }
                    }
                }
            }
            .padding()
            
            Button("Done") {
                dismiss()
            }
            .padding()
        }
    }
}

struct HostEventView_Previews: PreviewProvider {
    static var previews: some View {
        HostEventView()
    }
}
