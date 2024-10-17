//
//  AppDelegate.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import GoogleSignIn
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    //MARK: - Initializing code for Firebase (App Configuration)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
//        TokenManager.share.deleteToken()
//        UserDefaults.standard.set(false, forKey: "appState")
//        KeychainManager.shared.keychain.delete("appUserId")
        return true
    }
    
    //MARK: - Handle the URL that application receives at the end of the authentication process
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
