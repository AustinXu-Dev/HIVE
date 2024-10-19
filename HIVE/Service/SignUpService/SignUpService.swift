//
//  SignUpService.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

class SignUpService: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var dateOfBirth: String = ""
    @Published var gender: String = ""
    @Published var profileImageUrl: String = ""
    @Published var about: String = ""
    @Published var bio: String = ""
    @Published var instagramLink: String = ""
    @Published var isOrganizer: Bool = false
    @Published var isSuspened: Bool = false
    
    @Published var errorMessage: String? = nil

    func signUp() {
        let newUser = SignUpSchema(
            name: name,
            email: email,
            dateOfBirth: dateOfBirth,
            gender: gender,
            profileImageUrl: profileImageUrl,
            about: about,
            bio: bio,
            instagramLink: instagramLink,
            isOrganizer: isOrganizer,
            isSuspened: isSuspened,
            password: password
        )
        
        let signUpManager = SignUpUseCase()
        
        signUpManager.execute(data: newUser, getMethod: "POST", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    TokenManager.share.saveTokens(token: response.message.token)
                case .failure(let error):
                    self?.errorMessage = "Failed to sign up: \(error.localizedDescription)"
                }
            }
        }
    }
}

