//
//  EventCreationSuccessView.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 27/10/2024.
//


import SwiftUI

struct EventCreationSuccessView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl


    var body: some View {
        VStack(spacing: 40) {
            EmptyView()
            Spacer()
                Image("success_image")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                
                VStack(spacing: 8) {
                    Text("All set!")
                        .font(CustomFont.successTitle)
                        .fontWeight(.bold)
                    
                    Text("Your meet up is ready for others to join.")
                        .font(CustomFont.successSubtitle)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            
            Spacer()
            
            Button {
                appCoordinator.popToRoot()
                appCoordinator.setSelectedTab(index: .home)
            } label: {
                Text("Done")
                    .underline()
                    .font(CustomFont.onBoardingButtonFont)
                    .padding(.horizontal,24)
                    .padding(.vertical)
                    .foregroundStyle(Color.white)
                    .background(Color.black)
                    .cornerRadius(30)
                    .frame(width:350)

            }
            
            
            
        
        }
        .padding()
        .multilineTextAlignment(.center)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("HIVE")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:80,height:35)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EventCreationSuccessView()
}

