////
////  OrganizerProfile.swift
////  HIVE
////
////  Created by Swan Nay Phue Aung on 09/11/2024.
////
//
//import SwiftUI
//import Kingfisher
//struct ParticipantProfile: View {
//  
//  let user: UserModel
//  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
//  @StateObject var socialVM: GetSocialViewModel
//
//  
//  init(user:UserModel) {
//    self.user = user
//    _socialVM = StateObject(wrappedValue: GetSocialViewModel(userId: user._id ?? "" ))
//  }
//  
//  
//  
//  
//  var body: some View {
//    ZStack {
//      if socialVM.isLoading {
//        ProgressView()
//      } else {
//        VStack(spacing: 24) {
//          ZStack(alignment:.bottomTrailing){
//            KFImage(URL(string: user.profileImageUrl ?? ""))
//              .resizable()
//              .aspectRatio(contentMode: .fill)
//              .frame(width: 120, height: 120)
//              .clipShape(Circle())
//              .shadow(radius: 5)
//            if user.verificationStatus == VertificationEnum.approved.rawValue {
//              Image(systemName: "checkmark.seal.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width:30,height:30)
//                .foregroundColor(.blue)
//                .offset(y:-5)
//            }
//          }
//          Text(user.name ?? "Unknown User")
//            .font(CustomFont.profileTitle)
//            .fontWeight(.bold)
//          
//          if let participantBio = user.bio {
//            Text("(\(participantBio))")
//              .font(CustomFont.bioStyle)
//              .foregroundColor(.gray)
//          }
//          
//          
//          HStack {
//            VStack {
//              Text("\(socialVM.followers.count)")
//                .font(.system(size: 18))
//                .fontWeight(.bold)
//              Text("Followers")
//                .font(.caption)
//                .foregroundColor(.gray)
//            }
//            Spacer()
//            VStack {
//              Text("\(socialVM.followings.count)")
//                .font(.system(size: 18))
//                .fontWeight(.bold)
//              Text("Following")
//                .font(.caption)
//                .foregroundColor(.gray)
//            }
//          }
//          .padding(.horizontal, 116)
//          .padding(.vertical, 5)
//          .onTapGesture {
//            appCoordinator.push(.followerView(followingsSocial: socialVM.followings, follwersSocial: socialVM.followers, currentUser: user))
//          }
//          
//          
//          
//          
//          if let instagramLink = user.instagramLink, !instagramLink.isEmpty {
//            Button(action: {
//              if let url = URL(string: instagramLink) {
//                UIApplication.shared.open(url)
//              }
//            }) {
//              HStack {
//                Image("instagram")
//                  .aspectRatio(contentMode: .fill)
//                  .frame(width: 27, height: 27)
//                Text("Connect me")
//                  .font(.callout)
//                  .foregroundColor(.black)
//              }
//              .padding()
//              .frame(maxWidth: .infinity)
//              .background(Color.gray.opacity(0.2))
//              .cornerRadius(25)
//              .padding(.horizontal, 40)
//            }
//          }
//          
//          
//          
//          
//          
//          Spacer()
//            .toolbar {
//              ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                  appCoordinator.pop()
//                }) {
//                  Image(systemName: "chevron.left")
//                    .font(.title2)
//                    .foregroundColor(.black)
//                }
//              }
//            }
//          
//        }
//      }
//    }
//    .navigationBarBackButtonHidden()
//  }
//}
//
