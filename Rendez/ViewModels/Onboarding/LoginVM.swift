//
//  LoginVM.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import Foundation
import FirebaseAuth
import Firebase

extension LoginView {
    @Observable
    class LoginVM: ObservableObject {
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

        func signIn() {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self, let user = result?.user else {
                    self?.authError = error?.localizedDescription ?? "Sign in failed"
                    return
                }
                self.verifyUserType(userId: user.uid, status: status) { success in
                    if success {
                        self.isLoggedIn = true;
                        self.currentUser = user
                        self.status = self.status
                    } else {
                        self.signOut()
                        self.authError = "You don't have permission to sign in as this user type"
                    }
                }
            }
        }

        private func verifyUserType(userId: String, status: Status, completion: @escaping (Bool) -> Void) {
            let collection = status == .user ? "USERS" : "HOSTS"
            db.collection(collection).document(userId).getDocument { document, error in
                completion(document?.exists == true)
            }
        }

        func signOut() {
            do {
                try Auth.auth().signOut()
                currentUser = nil
            } catch {
                authError = "Failed to sign out"
            }
        }
    }
}
