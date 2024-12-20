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
            Text("HIVE")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding(.top, 50)

            Spacer()

            
            Image(systemName: isPrivate ? "" : "party.popper.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
            
            VStack(spacing: 8) {
                Text(isPrivate ? "Request Sent!" : "You're in!")
                    .font(CustomFont.successTitle)

                Text(isPrivate ? "Wait for the organizer to approve your request." : "Get ready for a great time.")
                    .font(CustomFont.successSubtitle)
                    .foregroundColor(.secondary)
            }
            
            if isPrivate == true {
                 Spacer()
             }

            Spacer()

            Button {
                appCoordinator.popToRoot()
            } label: {
                Text("Explore more")
                    .font(CustomFont.onBoardingButtonFont)
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
            }
        }
        .multilineTextAlignment(.center)
        .navigationBarBackButtonHidden()
    }
}


#Preview {
    EventJoinSuccessView(isPrivate: true)
}

