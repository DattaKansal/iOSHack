//
//  UserSignUp.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct SignupView: View {
    @State var status : Status
    @State private var welcome: Bool = false
    @State private var login: Bool = false
    @StateObject private var viewModel: SignupVM

    init(status: Status) {
        self.status = status
        _viewModel = StateObject(wrappedValue: SignupVM(status: status))
    }
    var body: some View {
        NavigationStack {
            NavigationLink(destination: LoginView(status: status), isActive: $login) {}
            NavigationLink(destination: WelcomeView(), isActive: $welcome) {}
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
                    .foregroundColor(Color.white)
                
                VStack(spacing: 20) {
                    TextField("Name", text: $viewModel.name)
                        .padding()
                        .autocapitalization(.none)
                        .foregroundStyle(Color.primaryBackground)
                        .background(Color.secondary)
                        .cornerRadius(30)
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundStyle(Color.primaryBackground)
                        .background(Color.secondary)
                        .cornerRadius(30)
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .autocapitalization(.none)
                        .foregroundStyle(Color.primaryBackground)
                        .background(Color.secondary)
                        .cornerRadius(30)
                    
                    Button(action: {
                        viewModel.signUp()
                    }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }

                    HStack(spacing: 0) {
                        Text("Already a member? ")
                            .font(Font.custom("SF Pro Rounded", size: 16))
                            .foregroundColor(.white)
                        Button {
                            self.login = true
                        } label: {
                            Text("Log In")
                                .font(Font.custom("SF Pro Rounded", size: 16))
                                .foregroundColor(.primary)
                                .underline()
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                
                Spacer()
            }
            .background(Color.primaryBackground)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.welcome = true;
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.primary)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    SignupView(status: .host)
}
