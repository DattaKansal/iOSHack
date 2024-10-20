//
//  SwiftUIView.swift
//  Rendez
//
//  Created by Suraj Mehrotra on 10/19/24.
//

import SwiftUI
import PhotosUI

struct CreateEventView: View {
//
//    @State private var tier1Price: Double = 50.0
//    @State private var tier2Price: Double = 100.0
//    @State private var tier1Tickets: Int = 50
//    @State private var tier2Tickets: Int = 50
    
    @State private var numberOfTiers: Int = 1
    @State private var totalTicketsInput: String = "100"
    @State private var showImagePicker = false
    
    @StateObject private var viewModel = HostEventViewModel()

    @State var tierCount = 1

    var body: some View {
        NavigationView {
            ScrollView {

                HStack {
                    Text("Create Event")
                        .font(.system(size: 40))
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
                .padding(.leading, 25)

                VStack(spacing: 20) {

                    eventDetailsSection
                    
                    imageSection

                    ticketingSection

                    waitlistSection

                    restrictionsSection
                    
                    Spacer()
                    
                    Button(action: {
                        // Action to Create Event

                        Task {
                            await viewModel.createEvent()
                        }

                        viewModel.createEvent()
                        HostHome()

                    }) {
                        Text("Create Event")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                    }
                    .padding(.horizontal)
                }
                .padding(25)
            }
            .background(Color.primaryBackground)
        }
    }

    var eventDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Details")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.secondary)

            VStack(spacing: 10) {
                TextField("Event Name", text: $viewModel.eventName)
                    .padding()
                    .foregroundStyle(Color.black)
                    .background(Color.secondary)
                    .cornerRadius(30)

                TextField("Location", text: $viewModel.loc)
                    .padding()
                    .foregroundStyle(Color.black)
                    .background(Color.secondary)
                    .cornerRadius(30)
                DatePicker("Start-Date", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
                    .tint(Color.primary)
                    .padding(.leading, 5)

                DatePicker("End-Date", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
                    .tint(Color.primary)
                    .padding(.leading, 5)

                TextField("Description", text: $viewModel.eventDescription)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .foregroundStyle(Color.black)
                    .background(Color.secondary)
                    .cornerRadius(30)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.thirdBackground))
            .shadow(radius: 5)
        }
    }
    
    var imageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Image")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            VStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(25)
                } else {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary)
                        .cornerRadius(25)
                }
                PhotosPicker("Add Image", selection: $viewModel.imageItem, matching: .images)
                    .tint(Color.black)
                    .onChange(of: viewModel.imageItem) { newItem in
                        Task {
                            if let newItem = newItem {
                                do {
                                    // Try to load the image data
                                    if let data = try await newItem.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        // Set the selected image
                                        viewModel.selectedImage = uiImage
                                    }
                                } catch {
                                    print("Error loading image: \(error)")
                                }
                            }
                        }
                    }
            }
            .frame(maxWidth: .infinity)  // Make sure it spans the available width
            .frame(height: 225)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.thirdBackground))
            .shadow(radius: 5)
        }
    }

    var ticketingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ticketing")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.secondary)

            VStack(spacing: 10) {
                Button(action: {
                    tierCount = tierCount + 1
                }) {
                    Label("Add Ticket Tier", systemImage: "plus.circle")
                        .tint(Color.primary)
                }
                VStack {
                    ForEach(0..<tierCount, id: \.self) {index in
                        TextField("Total Tickets", text: $totalTicketsInput, onCommit: {
                            viewModel.updateTotalTickets()
                        })
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                
                Spacer()
                HStack {
                    Text("Price Per Ticket:")
                    Spacer()
                    Text("$\(viewModel.pricePerTicket, specifier: "%.2f")")
                }
                .padding(.horizontal)
                Slider(value: $viewModel.pricePerTicket, in: 0...500, step: 5)
                    .accentColor(Color.primary)
                    .padding(.horizontal)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.thirdBackground))
            .shadow(radius: 5)
        }
    }
    
//    private func updateTotalTickets() {
//            if let value = Int(totalTicketsInput) {
//                viewModel.totalTickets = value
//            } else {
//                viewModel.totalTickets = 0
//            }
//        }


//    func adjustTiers() {
//        if numberOfTiers > viewModel.tiers.count {
//            let additionalTiers = numberOfTiers - viewModel.tiers.count
//            viewModel.tiers.append(contentsOf: Array(repeating: Tier(name: "", price: 50.0, numTickets: 50), count: additionalTiers))
//        } else if numberOfTiers < viewModel.tiers.count {
//            viewModel.tiers.removeLast(viewModel.tiers.count - numberOfTiers)
//        }
//    }

    var waitlistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable Waitlist", isOn: $viewModel.isWaitlistEnabled)
                .padding(.horizontal)
                .tint(Color.primary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25).fill(Color.thirdBackground))
        .shadow(radius: 5)
    }


    var restrictionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Restrictions")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.secondary)
            VStack {

                Stepper("Max Tickets Per Person: \(viewModel.maxTicketsPerPerson)", value: $viewModel.maxTicketsPerPerson, in: 1...15)
                    .accentColor(Color.primary)

            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).fill(Color.thirdBackground))
            .shadow(radius: 5)
        }

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


#Preview {
    HostEventView()
}

