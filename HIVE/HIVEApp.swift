//
//  HIVEApp.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/15.
//

import SwiftUI

@main
struct HIVEApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @AppStorage("appState") var isSingIn = false

    var body: some Scene {
        WindowGroup {
//            CoordinatorView()
            OnboardingView()
        }
    }
}
