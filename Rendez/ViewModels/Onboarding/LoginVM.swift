//
//  LoginVM.swift
//  Rendez
//
//  Created by Akshat Shenoi on 10/18/24.
//

import Foundation

extension LoginView {
    @Observable
    class LoginVM: ObservableObject {
        var email: String = ""
        var password: String = ""
        var status: Status

        init (status: Status) {
            self.status = status
        }
    }
}
