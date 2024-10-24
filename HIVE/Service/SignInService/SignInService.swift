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

    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    func signIn() {
        let credential = SignInSchema(
            email: email,
            password: password
        )
        
        let signInManager = SignInUseCase()
        
        signInManager.execute(data: credential, getMethod: "POST", token: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    TokenManager.share.saveTokens(token: response.message.token)
                case .failure(let error):
                    self.errorMessage = "Failed to sign in: \(error.localizedDescription)"
                    print("Error")
                }
            }
        }
    }
}
