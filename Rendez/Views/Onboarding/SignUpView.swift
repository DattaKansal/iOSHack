//
//  UserSignUp.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct SignUpView: View {
    @State var name : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var status : Status
    var body: some View {
        VStack {
            Spacer()

            // Image at the top
            Image(systemName: "ticket")  // Replace with your custom image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(.primary)  // Modify this color to match your design

            // Welcome Text
            let statusText = status != .user ? "Host" : "User"
            Text(statusText + " Sign Up")
                .font(.system(size: 28))
                .fontWeight(.medium)
                .foregroundColor(.white)

            VStack(spacing: 20) {
                TextField("Name", text: $name)
                    .padding()
                    .autocapitalization(.none)
                    .foregroundStyle(Color.bg)
                    .background(Color.primary)
                    .cornerRadius(30)
                TextField("Email", text: $email)
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .foregroundStyle(Color.bg)
                    .background(Color.primary)
                    .cornerRadius(30)
                SecureField("Password", text: $password)
                    .padding()
                    .autocapitalization(.none)
                    .foregroundStyle(Color.bg)
                    .background(Color.primary)
                    .cornerRadius(30)

                Button(action: {
                    // Action for Sign Up
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal, 40)


            // 'Sign Up' Button


            Spacer()
        }
        .background(Color.bg)
    }
}

#Preview {
    SignUpView(status: .host)
}
