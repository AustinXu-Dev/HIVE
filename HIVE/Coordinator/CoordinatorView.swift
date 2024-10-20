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
    @AppStorage("appState") var isSingIn = false

    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            if isSingIn{
//                appCoordinator.build(.home)
                appCoordinator.build(.eventCreationForm)
                    .navigationDestination(for: Screen.self) { screen in
                        appCoordinator.build(screen)
                    }
            } else {
                appCoordinator.build(.signIn)
                    .navigationDestination(for: Screen.self) { screen in
                        appCoordinator.build(screen)
                    }
            }
            
//                .sheet(item: $appCoordinator.sheet) { sheet in
//                    appCoordinator.build(sheet)
//                }
//                .fullScreenCover(item: $appCoordinator.fullScreenCover) { fullScreenCover in
//                    appCoordinator.build(fullScreenCover)
//                }
        }
        .environmentObject(appCoordinator)
    }
}
