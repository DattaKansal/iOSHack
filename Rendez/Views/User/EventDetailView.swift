//
//  EventDetailView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var tierCounts: [UUID: Int] = [:]
    @State private var isActive: Bool = false
    @State private var clientSecret: String?
    @State private var errorMessage: String?
    @State private var checkoutItems: [CheckoutItem] = []

    private func startCheckout() {
        let selectedTiers = event.tiers.compactMap { tier -> CheckoutItem? in
            guard let count = tierCounts[tier.id], count > 0 else { return nil }
            return CheckoutItem(
                name: tier.name,
                price: tier.price,
                quantity: count
            )
        }
        
        guard !selectedTiers.isEmpty else {
            self.errorMessage = "Please select at least one ticket"
            return
        }
        
        self.checkoutItems = selectedTiers
        
        guard let url = URL(string: "https://special-coffee-turkey.glitch.me/create-payment-intent") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        
        do {
            let payload = ["items": selectedTiers]
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
            print("Request payload: \(String(data: jsonData, encoding: .utf8) ?? "")")
        } catch {
            self.errorMessage = "Error encoding payload: \(error.localizedDescription)"
            return
        }
        
        print("Starting network request to \(url.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    if (error as NSError).code == NSURLErrorTimedOut {
                        self.errorMessage = "Request timed out. Please check your internet connection and try again."
                    } else if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                        self.errorMessage = "No internet connection. Please check your network settings and try again."
                    } else {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                    }
                    print("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Invalid response"
                    print("Invalid response")
                    return
                }
                
                print("HTTP Status code: \(httpResponse.statusCode)")
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    self.errorMessage = "Server error: HTTP \(httpResponse.statusCode)"
                    print("Server error: HTTP \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response body: \(responseString)")
                    }
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "No data received"
                    print("No data received")
                    return
                }
                
                
                do {
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response data: \(responseString ?? "")")
                    
                    let checkoutIntentResponse = try JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
                    self.clientSecret = checkoutIntentResponse.clientSecret
                    print("Client Secret received: \(checkoutIntentResponse.clientSecret)")
                    self.isActive = true
                    print("isActive set to true")
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = "Error decoding response: \(error.localizedDescription)"
                    print("Error decoding response: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
            if task.state == .running {
                task.cancel()
                self.errorMessage = "Request timed out. Please try again."
                print("Request timed out and was cancelled")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Image(event.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .clipped()
                    .ignoresSafeArea()
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 15) {
                        // Title and organization name
                        VStack(alignment: .leading, spacing: 5) {
                            Text(event.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text(event.orgName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Divider()
                            .background(Color.secondary)

                        // Description
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.secondary)

                        Divider()
                            .background(Color.secondary)
                        // Address and timings
                        HStack {
                            Image(systemName: "location")
                            Text(event.address)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                        HStack {
                            Image(systemName: "calendar")
                            Text(event.startDate)
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        Divider()
                            .background(Color.secondary)
                        // Tiers list
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ticket Tiers")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            //                        print(event.tiers.count)
                            ForEach(event.tiers.compactMap { $0 }) { tier in
                                TierView(tier: tier, count: tierCounts[tier.id] ?? 0) { newCount in
                                    tierCounts[tier.id] = newCount
                                }
                            }
                        }

                        Button(action: {
                            print("Book tickets button tapped")
                            startCheckout()
                        }) {
                            Text("Book Tickets")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.primary)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                        .padding(.top)
                        .disabled(tierCounts.values.reduce(0, +) == 0)

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }

                        NavigationLink(
                            destination: CheckoutView(clientSecret: clientSecret ?? "", checkoutItems: checkoutItems),
                            isActive: $isActive,
                            label: { EmptyView() }
                        )
                        .hidden()
                        Spacer()
                    }
                    .onChange(of: isActive) { newValue in
                        print("isActive changed to \(newValue)")
                    }
                    .onChange(of: clientSecret) { newValue in
                        print("clientSecret changed to \(newValue ?? "nil")")
                    }

                    
                    NavigationLink(
                        destination: CheckoutView(clientSecret: clientSecret ?? "", checkoutItems: checkoutItems),
                        isActive: $isActive,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
                .ignoresSafeArea()
                .background(Color.primaryBackground)
                .padding(10)
                .navigationBarTitleDisplayMode(.inline)
            }
            .scrollIndicators(.hidden)
            .background(Color.primaryBackground)

        }
        .navigationBarBackButtonHidden(true)
        .background(Color.primaryBackground)
    }
}
