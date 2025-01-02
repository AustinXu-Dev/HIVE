//
//  GoogleAuthenticationViewModel.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import SwiftUI
import Combine


class GoogleAuthenticationViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var uid = ""
    @Published var email = ""
    @ObservedObject var getAllUserVM = GetAllUsersViewModel()
  @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue


    var signInService = SignInService()
    var isNew: Bool?
    
    private var cancellables = Set<AnyCancellable>()
  let tokenExpirationManager = TokenExpirationManager.shared //already init here

  
    init() {
        // Initialize any necessary state here if needed
    }

    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Error?, Bool) -> Void) {
        
        guard let clientID = FirebaseManager.shared.firebaseApp?.options.clientID else {
            self.errorMessage = "Missing Firebase Client ID"
            DispatchQueue.main.async {
                completion(NSError(domain: "GoogleAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Firebase client ID."]), false)
            }
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                self.errorMessage = "Failed to Sign In with instance: \(error)"
                DispatchQueue.main.async {
                    completion(error, false)
                }
                return
            }
            
            guard let user = user?.user, let idToken = user.idToken else {
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            FirebaseManager.shared.auth.signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = "Failed to Sign In with credentials: \(error)"
                    DispatchQueue.main.async {
                        completion(error, false)
                    }
                    return
                }
                
                guard let authResult = authResult else {
                    self.errorMessage = "Authentication result is nil: \(String(describing: error))"
                    DispatchQueue.main.async {
                        completion(NSError(domain: "FirebaseAuthError", code: -1, userInfo: nil), false)
                    }
                    return
                }
                
                self.signInService.email = authResult.user.email ?? ""
                self.signInService.password = authResult.user.uid
                // Get the user details
                self.email = authResult.user.email ?? ""
                self.uid = authResult.user.uid
                
                // Fetch all users asynchronously
                self.getAllUserVM.getAllUsers()
                
                let isNewInFirebase = authResult.additionalUserInfo?.isNewUser ?? false
                if isNewInFirebase{
                    print("New user in firebase")
                   //MARK: -UserDefaults.standard.set(false, forKey: "appState")
                    completion(nil, true)
                } else {
                    // Observe userData updates to check if the use r exists
                    self.getAllUserVM.$userData
                        .sink { [weak self] userData in
                            guard let self = self, let users = userData else { return }
                            self.checkIfUserExists(in: users, result: authResult, completion: completion)
                        }
                        .store(in: &self.cancellables)
                }
            }
        }
    }

    // Function to check if a user with the same email exists
  
        
    private func checkIfUserExists(in users: [UserModel], result: AuthDataResult, completion: @escaping (Error?, Bool) -> Void) {
                var isUserExisting = false
                
                // Loop through users to check if any user's email matches the result user email
                for user in users {
                    if user.email == result.user.email {
                        isUserExisting = true
                        DispatchQueue.main.async {
                            print("Existing User")
                            self.signInService.signIn()
                          self.tokenExpirationManager.saveTokenExpirationDate()
                          
                          self.userAppState = AppState.signedIn.rawValue
                          print("User app state is \(self.userAppState)")
                            completion(nil, false) // Returning false for existing user
                        }
                        break
                    }
                }
                
                // If no existing user was found, handle as a new user
                if !isUserExisting {
                    DispatchQueue.main.async {
                        print("New User But not yet stored in backend")
                      //MARK: -UserDefaults.standard.set(false, forKey: "appState")
                        self.userAppState = AppState.notSignedIn.rawValue
                      print("User app state is \(self.userAppState)")
                        completion(nil, true) // Returning true for new user
                    }
                }
            }

        

        

    // Google Sign Out Function
    func signOutWithGoogle() {
        do {
            try FirebaseManager.shared.auth.signOut()
            TokenManager.share.deleteToken()
            KeychainManager.shared.keychain.delete("appUserId")
          UserDefaults.standard.removeObject(forKey: "TokenExpirationDate")
            DispatchQueue.main.async {
              //MARK: -UserDefaults.standard.set(false, forKey: "appState")
              self.userAppState = AppState.notSignedIn.rawValue
              print("User app state is \(self.userAppState)")
            }
        } catch let signOutError as NSError {
            self.errorMessage = "Failed to sign out with error: \(signOutError)"
        }
    }
}
