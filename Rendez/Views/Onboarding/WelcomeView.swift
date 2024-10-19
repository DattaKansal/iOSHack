//
//  WelcomeView.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct WelcomeView: View {
    @State private var hostSignUp: Bool = false
    @State private var userSignUp: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: SignUpView(status: .host), isActive: $hostSignUp) {
                }
                NavigationLink(destination: SignUpView(status: .user), isActive: $userSignUp) {
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
                    self.userSignUp = true;
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
                    self.hostSignUp = true;
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
            .background(Color.bg)
        }
    }
}

#Preview {
    WelcomeView()
}
