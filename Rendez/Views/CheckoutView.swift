//
//  CheckoutView.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//

import SwiftUI
import Stripe

struct CheckoutView: View {
    let clientSecret: String
    @State private var paymentMethodParams: STPPaymentMethodParams?
    @State private var message: String = ""
    @State private var isPaymentSuccessful: Bool = false
    @State private var isClientSecretValid: Bool = false
    
    private let paymentGatewayController = PaymentGatewayController()
    
    private func pay() {
        guard !clientSecret.isEmpty else {
            message = "Error: Invalid client secret"
            return
        }
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        
        paymentGatewayController.submitPayment(intent: paymentIntentParams) { status, intent, error in
            switch status {
            case .failed:
                message = "Payment failed: \(error?.localizedDescription ?? "Unknown error")"
            case .canceled:
                message = "Payment cancelled"
            case .succeeded:
                message = "Payment successful!"
                isPaymentSuccessful = true
            @unknown default:
                message = "Unknown payment status"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Complete Your Payment")
                .font(.title)
                .padding()
            
            if clientSecret.isEmpty {
                Text("Error: Invalid client secret")
                    .foregroundColor(.red)
            } else {
                STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams)
                    .padding()
                
                Button("Pay") {
                    pay()
                }
                .disabled(paymentMethodParams == nil)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Text(message)
                    .foregroundColor(isPaymentSuccessful ? .green : .red)
                
                if isPaymentSuccessful {
                    NavigationLink("Return to Events", destination: EventView())
                        .padding()
                }
            }
        }
        .padding()
        .navigationTitle("Checkout")
        .onAppear {
            print("CheckoutView appeared with client secret: \(clientSecret)")
            isClientSecretValid = !clientSecret.isEmpty
        }
    }
}
