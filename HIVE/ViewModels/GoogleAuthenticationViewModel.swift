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

class GoogleAuthenticationViewModel: ObservableObject{
    
    @Published var errorMessage = ""
    
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
            
            //MARK: - Trigerring SignIn Function from Firebase Auth
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
                
                //MARK: - Handling new user state during sign in
                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                if isNewUser{
                    completion(nil, true)
                    UserDefaults.standard.set(false, forKey: "appState")
                } else{
                    completion(nil, false)
                    UserDefaults.standard.set(true, forKey: "appState")
                }
                //MARK: - Condition with Token Valid and Login successful with google auth
            }
        }
    }
    
    //MARK: - Goolge Sign Out Function
    func signOutWithGoogle() {
        do {
            try FirebaseManager.shared.auth.signOut()
            DispatchQueue.main.async {
                UserDefaults.standard.set(false, forKey: "appState")
            }
        } catch let signOutError as NSError {
            self.errorMessage = "Failed to sign out with error: \(signOutError)"
        }
    }
}
