//
//  TabScreenView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/24.
//

import SwiftUI

struct TabScreenView: View {
    
    @State var selectedIndex: Int = 0
    @StateObject private var eventsVM = GetEventsViewModel()
    @Environment(\.isGuest) var isGuest

  @StateObject var profileVM = GetOneUserByIdViewModel()

    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView()
                .environmentObject(eventsVM)
                .environmentObject(profileVM)
                .tabItem {
                    Label(selectedIndex == 0 ? "---" : "", image: "home")
                }
                .tag(0)
            SearchView()
                .environmentObject(eventsVM)
                .environmentObject(profileVM)
                .tabItem {
                    Label(selectedIndex == 1 ? "---" : "", image: "search")
                }
                .tag(1)
            EventCreationView()
                .tabItem {
                    Label(selectedIndex == 2 ? "---" : "", image: "plus")
                }
                .tag(2)
           Text("Coming Soon")
                .bold()
                .font(.largeTitle)
                .tabItem {
                    Label(selectedIndex == 3 ? "---" : "", image: "messenger")
                }
                .tag(3)
            ProfileView()
            .environmentObject(profileVM)
                .tabItem {
                    Label(selectedIndex == 4 ? "---" : "", image: "user")
                }
                .tag(4)
        }
        .onAppear {
            eventsVM.fetchEvents()
              
              if let reterivedUserId = KeychainManager.shared.keychain.get("appUserId") {
              
              
              profileVM.getOneUserById(id: reterivedUserId)
              
            }
              
              
              
        }
    }
}

#Preview {
    TabScreenView()
}
