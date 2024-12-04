//
//  TabScreenView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/24.
//

import SwiftUI

struct TabScreenView: View {
    
  @EnvironmentObject private var eventsVM: GetEventsViewModel
  @Environment(\.isGuest) var isGuest
  @StateObject var profileVM = GetOneUserByIdViewModel()
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl

  
  var body: some View {
        TabView(selection: $appCoordinator.selectedTabIndex) {
          HomeView()
            .environmentObject(eventsVM)
            .environmentObject(profileVM)
            .tabItem {
              Label(appCoordinator.selectedTabIndex == .home ? "---" : "", image: "home")
            }
            .tag(Tab.home)
          SearchView()
            .environmentObject(profileVM)
            .tabItem {
              Label(appCoordinator.selectedTabIndex == .search ? "---" : "", image: "search")
            }
            .tag(Tab.search)
          EventCreationView()
            .tabItem {
              Label(appCoordinator.selectedTabIndex == .hostEvent ? "---" : "", image: "plus")
            }
            .tag(Tab.hostEvent)
          Text("Coming Soon")
            .bold()
            .font(.largeTitle)
            .tabItem {
              Label(appCoordinator.selectedTabIndex == .chat ? "---" : "", image: "messenger")
            }
            .tag(Tab.chat)
          ProfileView()
            .environmentObject(profileVM)
            .tabItem {
              Label(appCoordinator.selectedTabIndex == .profile ? "---" : "", image: "user")
            }
            .tag(Tab.profile)
        }
      
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3){
        if let reterivedUserId = KeychainManager.shared.keychain.get("appUserId") {
          print("reterivedUserId: \(reterivedUserId)")
          profileVM.getOneUserById(id: reterivedUserId)
        }
      }
    }
    }
}

#Preview {
    TabScreenView()
}
