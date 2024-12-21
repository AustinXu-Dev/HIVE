////
////  OrganizerProfile.swift
////  HIVE
////
////  Created by Swan Nay Phue Aung on 09/11/2024.
////
//
//import SwiftUI
//import Kingfisher
//struct OrganizerProfile: View {
//  
//  let organizer: UserModel
//  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
//  @StateObject var socialVM: GetSocialViewModel
//
//  
//  init(organizer:UserModel) {
//    self.organizer = organizer
//    _socialVM = StateObject(wrappedValue: GetSocialViewModel(userId: organizer._id ?? "" ))
//  }
//  
//  
//  var body: some View {
//    VStack(spacing: 24) {
//      KFImage(URL(string: organizer.profileImageUrl ?? ""))
//        .resizable()
//        .aspectRatio(contentMode: .fill)
//        .frame(width: 120, height: 120)
//        .clipShape(Circle())
//        .shadow(radius: 5)
//      
//      
//      
//      
//      Text(organizer.name ?? "Unknown Host")
//        .font(CustomFont.profileTitle)
//        .fontWeight(.bold)
//      
//      if let organizerBio = organizer.bio {
//        Text("(\(organizerBio))")
//          .font(CustomFont.bioStyle)
//          .foregroundColor(.gray)
//      }
//      
//      
//      
//      HStack {
//          VStack {
//            Text("\(socialVM.followers.count)")
//                  .font(.system(size: 18))
//                  .fontWeight(.bold)
//              Text("Followers")
//                  .font(.caption)
//                  .foregroundColor(.gray)
//          }
//          Spacer()
//          VStack {
//            Text("\(socialVM.followings.count)")
//                  .font(.system(size: 18))
//                  .fontWeight(.bold)
//              Text("Following")
//                  .font(.caption)
//                  .foregroundColor(.gray)
//          }
//      }
//      .padding(.horizontal, 116)
//      .padding(.vertical, 5)
//      .onTapGesture {
//        appCoordinator.push(.followerView(followingsSocial: socialVM.followings, follwersSocial: socialVM.followers, currentUser: organizer))
//      }
//      
//      
//      if let instagramLink = organizer.instagramLink, !instagramLink.isEmpty {
//        Button(action: {
//        if let url = URL(string: instagramLink) {
//        UIApplication.shared.open(url)
//        }
//        }) {
//        HStack {
//        Image("instagram")
//        .aspectRatio(contentMode: .fill)
//        .frame(width: 27, height: 27)
//        Text("Connect me")
//        .font(.callout)
//        .foregroundColor(.black)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.gray.opacity(0.2))
//        .cornerRadius(25)
//        .padding(.horizontal, 40)
//        }
//      }
//      
//      Spacer()
//        .toolbar {
//          ToolbarItem(placement: .topBarLeading) {
//            Button(action: {
//              appCoordinator.pop()
//            }) {
//              Image(systemName: "chevron.left")
//                .font(.title2)
//                .foregroundColor(.black)
//            }
//          }
//        }
//        .navigationBarBackButtonHidden()
//    }
//  }
//}
//
