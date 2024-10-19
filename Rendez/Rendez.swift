//
//  iOSHackApp.swift
//  iOSHack
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI
import FirebaseCore

extension Color {
    static let primaryBackground = Color("primaryBackground") // From asset catalog
    static let secondaryBackground = Color("secondaryBackground")
    static let primary = Color(red: 172/255, green: 216/255, blue: 170/255)
    static let secondary = Color(red: 147/255, green: 133/255, blue: 129/255)
    static let bg = Color(red: 51/255, green: 51/255, blue: 51/255)
}

enum Status {
    case user
    case host
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Rendez: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
