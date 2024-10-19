//
//  Test.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

class SignInService: ObservableObject {
    
    @Published var email: String
    @Published var password: String
    @Published var errorMessage: String? = nil
    @Published var token: String? = nil
    @Published var userId: String? = nil

    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    func signIn() {
        let credential = SignInModel(
            email: email,
            password: password
        )
        
        let signInManager = SignInUseCase()
        
        signInManager.execute(data: credential, getMethod: "POST", token: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.token = response.message.token
                    self.userId = response.message.user._id
                    print("Sign-in successful. Token: \(response.message.token), User ID: \(response.message.user._id)")
                case .failure(let error):
                    self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
                }
            }
        }
    }
}
