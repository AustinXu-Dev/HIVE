//
//  HomeView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var eventsVM = GetEventsViewModel()
  
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment:.center) {
                    headerRow
                    if TokenManager.share.getToken() == nil {
                        accountCreationButton
                    }
                    eventsScollView
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}


extension HomeView {
    
    private var headerRow : some View {
        HStack {
            Image("HIVE")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:78,height:34)
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .frame(width:133,height:34)
                .foregroundStyle(.gray)
            
        }
    }
    
    private var accountCreationButton : some View {
        VStack {
            Text("Ready to Connect?")
                .bold()
                
            Button {
                
            } label: {
                Text("Create an Account")
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
           
            Text("To join or host your own!")
                .bold()
            
        }
    }
    
    private var eventsScollView : some View {
        VStack(alignment:.leading){
            Text("Explore")
                .padding(.horizontal)

            ScrollView(.vertical,showsIndicators: false){
                VStack(spacing:30){
                    ForEach(eventsVM.events,id: \._id){ event in
                        EventCard(event: event)
                        
                        
                    }
                }
            }
            
        }
    }
    
    
}
