//
//  iOSHackApp.swift
//  iOSHack
//
//  Created by Datta Kansal on 10/18/24.
//

import SwiftUI
import FirebaseCore

extension Color {
    static let primaryBackground = Color(red: 81/255, green: 59/255, blue: 69/255) // rose ebony
    static let secondBackground = Color(red: 221/255, green: 151/255, blue: 135/255) // coral pink
    static let thirdBackground = Color(red: 156/255, green: 133/255, blue: 133/255) // wenge
    static let primary = Color(red: 114/255, green: 189/255, blue: 163/255) // cambridge blue
    static let secondary = Color(red: 231/255, green: 207/255, blue: 205/255) // pale dogwood
    static let tertiary = Color(red: 2/255, green: 60/255, blue: 64/255) // midnight green
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
