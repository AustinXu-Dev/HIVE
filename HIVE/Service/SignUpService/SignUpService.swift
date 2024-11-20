//
//  SignUpService.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation
import SwiftUI

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
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue

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
        
        signUpManager.execute(data: newUser, getMethod: "POST", token: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("got singup response")
                    TokenManager.share.saveTokens(token: response.message.token)
                    KeychainManager.shared.keychain.set(response.message.user._id, forKey: "appUserId")
                  //  UserDefaults.standard.set(true, forKey: "appState")
                  self.userAppState = AppState.signedIn.rawValue
                  print("user App State \(self.userAppState)")
                case .failure(let error):
                    self.errorMessage = "Failed to sign up: \(error.localizedDescription)"
                }
            }
        }
    }
}

