//
//  TabScreenView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/24.
//

import SwiftUI

struct TabScreenView: View {
    
    @State var selectedIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView()
                .tabItem {
                    Label(selectedIndex == 0 ? "---" : "", image: "home")
                }
                .tag(0)
            SearchView()
                .tabItem {
                    Label(selectedIndex == 1 ? "---" : "", image: "search")
                }
                .tag(1)
            EventCreationView()
                .tabItem {
                    Label(selectedIndex == 2 ? "---" : "", image: "plus")
                }
                .tag(2)
            EmptyView()
                .tabItem {
                    Label(selectedIndex == 3 ? "---" : "", image: "messenger")
                }
                .tag(3)
            ProfileView()
                .tabItem {
                    Label(selectedIndex == 4 ? "---" : "", image: "user")
                }
                .tag(4)
        }
    }
}

#Preview {
    TabScreenView()
}
