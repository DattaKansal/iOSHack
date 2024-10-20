//
//  CheckoutView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI
import Stripe

struct CheckoutItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let price: Double
    let quantity: Int
}

struct CheckoutView: View {
    let clientSecret: String
    let checkoutItems: [CheckoutItem]  // New parameter
    
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @State private var message: String = ""
    @State private var isPaymentSuccessful: Bool = false
    @State private var isProcessing: Bool = false
    
    private let paymentGatewayController = PaymentGatewayController()
    
    private func pay() {
        guard !clientSecret.isEmpty else {
            message = "Error: Invalid client secret"
            return
        }
        
        isProcessing = true
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
            isProcessing = false
            switch status {
            case .failed:
                message = "Payment failed: \(error?.localizedDescription ?? "Unknown error")"
            case .canceled:
                message = "Payment cancelled"
            case .succeeded:
                message = "Payment successful!"
                isPaymentSuccessful = true
                confirmSuccessfulPayment()
            @unknown default:
                message = "Unknown payment status"
            }
        }
    }
    
    private func confirmSuccessfulPayment() {
        // TODO: Implement successful payment confirmation
        // - Update user's ticket inventory
        // - Send confirmation email
        // - Log transaction in database
        // - Update event attendance count
        print("Payment confirmed successfully")
    }
    
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    if clientSecret.isEmpty {
                        Text("Error: Invalid client secret")
                            .foregroundColor(.red)
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Your Items")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ForEach(checkoutItems) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Text("\(item.quantity)x")
                                    Text("$\(String(format: "%.2f", item.price))")
                                }
                                .foregroundColor(.secondary)
                            }
                            
                            Divider().background(Color.secondary)
                            
                            HStack {
                                Text("Total")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", checkoutItems.reduce(0) { $0 + $1.price * Double($1.quantity) }))")
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.thirdBackground)
                        .cornerRadius(10)
                    
                    STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams)
                        .padding()
                        .background(Color.secondary)
                        .cornerRadius(10)
                    
                    Button(action: pay) {
                        Text(isProcessing ? "Processing..." : "Pay Now")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isProcessing ? Color.gray : Color.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(paymentMethodParams == nil || isProcessing)
                    
                    Text(message)
                        .foregroundColor(isPaymentSuccessful ? .green : .red)
                        .padding()
                    
                    if isPaymentSuccessful {
                        NavigationLink("Return to Events", destination: EventView())
                            .padding()
                            .background(Color.secondary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Checkout")
        .onAppear {
            print("CheckoutView appeared with client secret: \(clientSecret)")
        }
    }
}
