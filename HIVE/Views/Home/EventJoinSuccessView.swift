//
//  WelcomeView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 19/10/2567 BE.
//

import SwiftUI

struct EventJoinSuccessView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    let isPrivate: Bool // Determines if the event is private or public

    var body: some View {
        VStack(spacing: 40) {
            
          Spacer()
              Image("success_image")
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              
            VStack(spacing: 8) {
                Text(isPrivate ? "Request Sent!" : "You're in!")
                  .heading1()
                  .foregroundStyle(Color.black)

                Text(isPrivate ? "Wait for the organizer to approve your request." : "Get ready for a great time.")
                    .body6()
                    .foregroundColor(Color.black)
            }
            
            if isPrivate == true {
                 Spacer()
             }

            Spacer()

            Button {
                appCoordinator.popToRoot()
            } label: {
                Text("Explore more")
                  .body3()
                  .underline()
                  .foregroundColor(.black.opacity(0.5))
                  .padding(.bottom, 30)
            }
        }
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
    EventJoinSuccessView(isPrivate: true)
}

