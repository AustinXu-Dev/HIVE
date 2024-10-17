//
//  ContentView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/15.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button {
//                appCoordinator.push(.signIn)
            } label: {
                Text("test")
            }

            
            Button {
                googleVM.signOutWithGoogle()
            } label: {
                Text("Sign out")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
