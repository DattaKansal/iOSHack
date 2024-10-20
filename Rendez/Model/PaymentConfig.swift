//
//  PaymentConfig.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//
import Foundation

class PaymentConfig {
    var paymentIntentClientSecret: String?
    static var shared: PaymentConfig = PaymentConfig()
}
