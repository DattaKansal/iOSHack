//
//  WelcomeView.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct WelcomeView: View {
    @State private var hostSignup: Bool = false
    @State private var userSignup: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: SignupView(status: .host), isActive: $hostSignup) {
                }
                NavigationLink(destination: SignupView(status: .user), isActive: $userSignup) {
                }
                Spacer()

                // Image at the top
                Image(systemName: "ticket")  // Replace with your custom image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.primary)  // Modify this color to match your design

                // Welcome Text
                Text("Welcome to")
                    .font(.system(size: 28))
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                Text("Rendez!")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                // 'Attend an Event' Button
                Button(action: {
                    self.userSignup = true;
                }) {
                    Text("Attend an Event")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                // OR Divider
                HStack {
                    VStack{
                        Divider()
                            .overlay(.white)
                    }
                    Text("or")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    VStack{
                        Divider()
                            .overlay(.white)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)

                // 'Host an Event' Button
                Button(action: {
                    self.hostSignup = true;
                }) {
                    Text("Host an Event")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .background(Color.primaryBackground)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WelcomeView()
}
