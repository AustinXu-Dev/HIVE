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
  @ObservedObject var googleVM = GoogleAuthenticationViewModel()
  @StateObject var socialVM: GetSocialViewModel
  @StateObject var eventHistoryVM: EventHistoryViewModel

  @StateObject private var tokenExpirationManager = TokenExpirationManager.shared

  init(){
      let userId = KeychainManager.shared.keychain.get("appUserId")
      _socialVM = StateObject(wrappedValue: GetSocialViewModel(userId: userId ?? ""))
      _eventHistoryVM = StateObject(wrappedValue: EventHistoryViewModel(userId: userId ?? ""))
  }
  
  var body: some View {
    TabView(selection: $appCoordinator.selectedTabIndex) {
      HomeView()
        .environmentObject(eventsVM)
        .environmentObject(profileVM)
        .environmentObject(socialVM)
        .environmentObject(eventHistoryVM)
        .tabItem {
          Label(appCoordinator.selectedTabIndex == .home ? "---" : "", image: "home")
        }
        .tag(Tab.home)
      SearchView()
        .environmentObject(profileVM)
        .environmentObject(socialVM)
        .environmentObject(eventHistoryVM)
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
        .environmentObject(socialVM)
        .environmentObject(eventHistoryVM)
        .tabItem {
          Label(appCoordinator.selectedTabIndex == .profile ? "---" : "", image: "user")
        }
        .tag(Tab.profile)
    }
    

    .alert(isPresented: $tokenExpirationManager.tokenIsExpired) {
      Alert(
        title: Text("Session Expired"),
        message: Text("Your session has expired. Please sign in again."),
        dismissButton: .default(Text("Sign In Again")) {
          googleVM.signOutWithGoogle()
        }
      )
    }
    
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3){
        if let reterivedUserId = KeychainManager.shared.keychain.get("appUserId") {
          print("reterivedUserId: \(reterivedUserId)")
          profileVM.getOneUserById(id: reterivedUserId)
          socialVM.fetchUserData(userId: reterivedUserId)
          eventHistoryVM.getAllEventHistories(userId: reterivedUserId)
          
                 
        }
      }
    }
  }
}

#Preview {
  TabScreenView()
}
