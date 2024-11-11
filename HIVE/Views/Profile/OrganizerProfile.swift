//
//  OrganizerProfile.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 09/11/2024.
//

import SwiftUI
import Kingfisher
struct OrganizerProfile: View {
  
  let organizer: OrganizerModel
  
  var body: some View {
    VStack(spacing: 24) {
      KFImage(URL(string: organizer.profileImageUrl ?? ""))
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .shadow(radius: 5)
      
      
      
      
      Text(organizer.name ?? "Unknown Host")
        .font(CustomFont.profileTitle)
        .fontWeight(.bold)
      
      if let organizerBio = organizer.bio {
        Text("(\(organizerBio))")
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
    }
  }
}

#Preview {
  OrganizerProfile(organizer: OrganizerMock.instance.organizer)
}
