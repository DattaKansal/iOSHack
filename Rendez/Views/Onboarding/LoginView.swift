//
//  SignUpView.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct LoginView: View {
    @State var status : Status
    @State private var signup: Bool = false
    @State private var welcome: Bool = false
    @State private var userHome: Bool = false
    @State private var hostHome: Bool = false
    @StateObject private var viewModel: LoginVM

    init(status: Status) {
        self.status = status
        _viewModel = StateObject(wrappedValue: LoginVM(status: status))
    }
    var body: some View {
        NavigationStack {
            NavigationLink(destination: SignupView(status: status), isActive: $signup) {}
            NavigationLink(destination: WelcomeView(), isActive: $welcome) {}
            NavigationLink(destination: UserHome(), isActive: $userHome) {}
            NavigationLink(destination: HostHome(), isActive: $hostHome) {}
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
                Text(statusText + " Log In")
                    .font(.system(size: 28))
                    .fontWeight(.medium)
                    .foregroundColor(.white)

                VStack(spacing: 20) {
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
                        viewModel.signIn()
                    }) {
                        Text("Log In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(.black)
                            .cornerRadius(30)
                    }

                    HStack(spacing: 0) {
                        Text("Not a member? ")
                            .font(Font.custom("SF Pro Rounded", size: 16))
                            .foregroundColor(.white)
                        Button {
                            self.signup = true
                        } label: {
                            Text("Sign Up")
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
        .onChange(of: viewModel.isLoggedIn) { _, newValue in
            if newValue {
                if (self.status == .user) {
                    self.userHome = true
                } else {
                    self.hostHome = true;
                }
            }
        }

    }
}

#Preview {
    LoginView(status: .user)
}
