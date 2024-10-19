//
//  EventDetailView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI

// New Codable struct for items
struct CheckoutItem: Codable {
    let name: String
    let amount: Int
    let quantity: Int
}

struct EventDetailView: View {
    let event: Event
    @State private var tierCounts: [UUID: Int] = [:]
    @State private var isActive: Bool = false
    @State private var clientSecret: String?
    
    private func startCheckout() {
        let selectedTiers = event.tiers.compactMap { tier -> CheckoutItem? in
            guard let tier = tier, let count = tierCounts[tier.id], count > 0 else { return nil }
            return CheckoutItem(
                name: tier.name,
                amount: Int(tier.price * 100),
                quantity: count
            )
        }
        
        let url = URL(string: "http://localhost:4242/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the items using the new CheckoutItem struct
        let payload = ["items": selectedTiers]
        request.httpBody = try? JSONEncoder().encode(payload)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error in network request: \(error.localizedDescription)")
                return
            }
            guard let data = data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Invalid response or status code")
                return
            }
//            guard let data = data, error == nil,
//                  (response as? HTTPURLResponse)?.statusCode == 200 else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
            
            do {
                let checkoutIntentResponse = try JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
                DispatchQueue.main.async {
                    self.clientSecret = checkoutIntentResponse.clientSecret
                    print("Client secret set: \(self.clientSecret ?? "nil")")
                    self.isActive = true
                    print("isActive set to true")
                }
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    var body: some View {
        ScrollView {
            // ... (rest of your existing view code)
            VStack(alignment: .leading, spacing: 0) {
                // Top image
                Image(event.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .clipped()
                
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
                    
                    // Description
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Address and timings
                    HStack {
                        Image(systemName: "location")
                        Text(event.address)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(event.date)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    // Tiers list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ticket Tiers")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ForEach(event.tiers.compactMap { $0 }) { tier in
                            TierView(tier: tier, count: tierCounts[tier.id] ?? 0) { newCount in
                                tierCounts[tier.id] = newCount
                            }
                        }
                    }
                    
                    Button(action: {print("Book tickets button tapped")
                        startCheckout()}) {
                        Text("Book Tickets")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding(.top)
                    .disabled(tierCounts.values.reduce(0, +) == 0)
                    
                    NavigationLink(
                        destination: CheckoutView(clientSecret: clientSecret ?? ""),
                        isActive: $isActive
                    ) {
                        EmptyView()
                    }
                    .onChange(of: isActive) { newValue in
                        print("isActive changed to \(newValue)")
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color.primaryBackground)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//
//struct EventDetailView: View {
//    let event: Event
//    @State private var tierCounts: [UUID: Int] = [:]
//    @State private var isActive: Bool = false
//
//    private func startCheckout(completion: @escaping (String?) -> Void) {
//        let url = URL(string: "https://special-coffee-turkey.glitch.me/create-payment-intent")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONEncoder().encode(["eventId": event.id])
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil,
//                  (response as? HTTPURLResponse)?.statusCode == 200
//            else {
//                completion(nil)
//                return
//            }
//            let checkoutIndentResponse = try?
//            JSONDecoder().decode(CheckoutIntentResponse.self, from: data)
//            completion(checkoutIndentResponse?.clientSecret)
//        }.resume()
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 0) {
//                // Top image
//                Image(event.imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: UIScreen.main.bounds.height * 0.4)
//                    .clipped()
//
//                VStack(alignment: .leading, spacing: 15) {
//                    // Title and organization name
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text(event.title)
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                        Text(event.orgName)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//
//                    // Description
//                    Text(event.description)
//                        .font(.body)
//                        .foregroundColor(.secondary)
//
//                    // Address and timings
//                    HStack {
//                        Image(systemName: "location")
//                        Text(event.address)
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//
//                    HStack {
//                        Image(systemName: "calendar")
//                        Text(event.date)
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//
//                    // Tiers list
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Ticket Tiers")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//
//                        ForEach(event.tiers.compactMap { $0 }) { tier in
//                            TierView(tier: tier, count: tierCounts[tier.id] ?? 0) { newCount in
//                                tierCounts[tier.id] = newCount
//                            }
//                        }
//                    }
//
//                    // Book tickets button
//                    Button(action: {
//                        startCheckout { clientSecret in
//                            DispatchQueue.main.async {
//                                if let clientSecret = clientSecret {
//                                    PaymentConfig.shared.paymentIntentClientSecret = clientSecret
//                                    DispatchQueue.main.async {
//                                        isActive = true
//                                    }
//                                }
//                            }
//                        }
//                    }) {
//                        Text("Book Tickets")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.primary)
//                            .foregroundColor(.white)
//                            .cornerRadius(30)
//                    }
//                    .padding(.top)
//                    .disabled(tierCounts.values.reduce(0, +) == 0)
//
//                    // NavigationLink to CheckoutView
//                    NavigationLink(
//                        destination: CheckoutView(),
//                        isActive: $isActive
//                    ) {
//                        EmptyView()
//                    }
//                }
//                .padding()
//            }
//        }
//        .edgesIgnoringSafeArea(.top)
//        .background(Color.primaryBackground)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//
//#Preview {
//    EventDetailView(event: Event(title: "Robot Speaker Event", description: "Learn and play with some robots", price: 0, orgName: "Robojackets", address: "SCC", date: "Nov 1 8-10 pm", imageName: "robot", tiers: [Tier(name: "Tier 1", price: 15, numTickets: 50), Tier(name: "Tier 2", price: 30, numTickets: 100)]))
//}
//
//
//
