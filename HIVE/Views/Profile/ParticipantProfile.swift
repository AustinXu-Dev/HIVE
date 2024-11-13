//
//  OrganizerProfile.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 09/11/2024.
//

import SwiftUI
import Kingfisher
struct ParticipantProfile: View {
  
  let participant: ParticipantModel
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl

  
  var body: some View {
    VStack(spacing: 24) {
      KFImage(URL(string: participant.profileImageUrl ?? ""))
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .shadow(radius: 5)
      
      
      
      
      Text(participant.name ?? "Unknown User")
        .font(CustomFont.profileTitle)
        .fontWeight(.bold)
      
      if let participantBio = participant.bio {
        Text("(\(participantBio))")
          .font(CustomFont.bioStyle)
          .foregroundColor(.gray)
      }
      
      /*
       
       if let instagramLink = profileVM.userDetail?.instagramLink, !instagramLink.isEmpty {
       Button(action: {
       if let url = URL(string: instagramLink) {
       UIApplication.shared.open(url)
       }
       }) {
       HStack {
       Image("instagram")
       .aspectRatio(contentMode: .fill)
       .frame(width: 27, height: 27)
       Text("Connect me")
       .font(.callout)
       .foregroundColor(.black)
       }
       .padding()
       .frame(maxWidth: .infinity)
       .background(Color.gray.opacity(0.2))
       .cornerRadius(25)
       .padding(.horizontal, 40)
       }
       }
       */
      Spacer()
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button(action: {
              appCoordinator.pop()
            }) {
              Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.black)
            }
          }
        }
        .navigationBarBackButtonHidden()
    }
  }
}

#Preview {
  ParticipantProfile(participant: ParticipantMock.instance.participantA)
}
