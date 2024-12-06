//
//  CoordinatorView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI

struct CoordinatorView: View {
    @StateObject var appCoordinator: AppCoordinatorImpl = AppCoordinatorImpl()
//    @AppStorage("appState") var isSingIn = false
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue

    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
          
          
          switch appState {
          case .signedIn:
            appCoordinator.build(.tab)
              .environment(\.isGuest, false)
              .navigationDestination(for: Screen.self) { screen in
                appCoordinator.build(screen)
              }
          case .guest:
            appCoordinator.build(.tab)
              .environment(\.isGuest, true)
              .navigationDestination(for: Screen.self) { screen in
                appCoordinator.build(screen)
              }
          case .notSignedIn:
            appCoordinator.build(.signIn)
                .navigationDestination(for: Screen.self) { screen in
                    appCoordinator.build(screen)
                }
          }
          
          /*
            if isSingIn{
                appCoordinator.build(.tab)
                    .navigationDestination(for: Screen.self) { screen in
                        appCoordinator.build(screen)
                    }
            } else {
                appCoordinator.build(.signIn)
                    .navigationDestination(for: Screen.self) { screen in
                        appCoordinator.build(screen)
                    }
            }
          
          */
            
//                .sheet(item: $appCoordinator.sheet) { sheet in
//                    appCoordinator.build(sheet)
//                }
//                .fullScreenCover(item: $appCoordinator.fullScreenCover) { fullScreenCover in
//                    appCoordinator.build(fullScreenCover)
//                }
        }
        .environmentObject(appCoordinator)
      
      
      
    }
  
  //reterives from app storeage and convert to
  private var appState: AppState {
      get { AppState(rawValue: userAppState) ?? .notSignedIn }
      set { userAppState = newValue.rawValue }
  }

  
  
}

