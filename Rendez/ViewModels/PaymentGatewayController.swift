//
//  PaymentGatewayController.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//


import Stripe
import SwiftUI

class PaymentGatewayController: NSObject {
    func submitPayment(intent: STPPaymentIntentParams, completion: @escaping (STPPaymentHandlerActionStatus, STPPaymentIntent?, NSError?) -> Void) {
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(intent, with: self) { (status, intent, error) in
            completion(status, intent, error)
        }
    }
}

extension PaymentGatewayController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        // Return the current view controller
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController ?? UIViewController()
    }
}
