//
//  LoginVM.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import Foundation
import Firebase
import FirebaseAuth

extension SignupView {
    @Observable
    class SignupVM: ObservableObject {
        var name: String = ""
        var email: String = ""
        var password: String = ""
        var status: Status
        var authError: String = ""
        var currentUser: User?
        var isLoggedIn: Bool = false

        private var db = Firestore.firestore()

        init (status: Status) {
            self.status = status
        }

        func signUp() {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self, let user = result?.user else {
                    self?.authError = error?.localizedDescription ?? "Sign up failed"
                    return
                }
                self.currentUser = user
                self.addUserToCollection(user: user, status: status)
                self.isLoggedIn = true;
            }
        }

        private func addUserToCollection(user: User, status: Status) {
            let collection = status == .user ? "USERS" : "HOSTS"
            db.collection(collection).document(user.uid).setData([
                "name": name ?? "",
                "email": user.email ?? "",
                "createdAt": Timestamp(date: Date())
            ]) { [weak self] error in
                if let error = error {
                    self?.authError = error.localizedDescription
                } else {
                    self?.status = status
                }
            }
        }


    }
}
