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
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Your meet up is ready for others to join.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            
            Spacer()
            
            Button {
                appCoordinator.popToRoot()
            } label: {
                Text("Done")
                    .font(.system(size: 30))
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
                Text("HIVE")
                .font(.largeTitle)
                .fontWeight(.medium)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    EventCreationSuccessView()
}
