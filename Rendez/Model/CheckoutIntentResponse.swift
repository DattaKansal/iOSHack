//
//  CheckoutIntentResponse.swift
//  Rendez
//
//  Created by Datta Kansal on 10/19/24.
//
import Foundation

struct CheckoutIntentResponse: Decodable {
    let clientSecret: String
    let dpmCheckerLink: String
}
