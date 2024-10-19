//
//  UserSignUp.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import SwiftUI

struct UserSignUp: View {
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
            Text("Sign Up!")
                .font(.system(size: 28))
                .fontWeight(.medium)
                .foregroundColor(.white)

            

            // 'Attend an Event' Button
            Button(action: {
                // Action for attend event
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
                // Action for host event
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

#Preview {
    UserSignUp()
}
