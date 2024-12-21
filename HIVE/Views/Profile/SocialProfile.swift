//MARK: - refactor later for reusability ( this is view for social profile )
import SwiftUI
import Kingfisher
struct SocialProfile: View {
  
  let social: UserModel
  @EnvironmentObject var appCoordinator: AppCoordinatorImpl
  @StateObject var socialVM: GetSocialViewModel
  @StateObject var userFollowVM = UserFollowViewModel()
  @StateObject var eventHistoryVM: EventHistoryViewModel

  init(social:UserModel) {
    self.social = social
    _socialVM = StateObject(wrappedValue: GetSocialViewModel(userId: social._id ?? ""))
    _eventHistoryVM = StateObject(wrappedValue: EventHistoryViewModel(userId: social._id ?? ""))
  }
  
  var body: some View {
    ZStack {
      if socialVM.isLoading && eventHistoryVM.isLoading {
        ProgressView("Loading...")
      } else {
        ScrollView(.vertical,showsIndicators: false){
        VStack(spacing: 24) {
          socialProfilePhoto
          nameAndInstagram
          aboutSection
          followersAndFollowings
          if let userId = KeychainManager.shared.keychain.get("appUserId"), userId != social._id {
            followButton
              .disabled(userFollowVM.followedButtonClicked || socialVM.alreadyFollowing)
          }
          bio
          EventHistory(viewModel: eventHistoryVM)
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
        }
      }
        .refreshable {
          socialVM.fetchUserData(userId: social._id ?? "")
          eventHistoryVM.getAllEventHistories(userId: social._id ?? "")
          
        }
    }
  }
   
    .navigationBarBackButtonHidden()
    .alert(isPresented: $userFollowVM.showErrorAlert){
      Alert(title: Text("Unknown Error Occured"),
            message: Text(userFollowVM.errorMessage),
            dismissButton: .cancel(Text("OK"))
      )
    }
  }
}


extension SocialProfile {
  private var socialProfilePhoto: some View {
    ZStack(alignment:.bottomTrailing){
      KFImage(URL(string: social.profileImageUrl ?? ""))
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 120, height: 120)
        .clipShape(Circle())
        .shadow(radius: 5)
      if social.verificationStatus == VertificationEnum.approved.rawValue {
        Image(systemName: "checkmark.seal.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width:30,height:30)
          .foregroundColor(.blue)
          .offset(y:-5)
      }
    }
  }
  
  private var nameAndInstagram: some View {
    HStack(spacing:12){
      Text(social.name ?? "")
        .font(CustomFont.profileTitle)
        .fontWeight(.bold)
      if let instagramLink = social.instagramLink, !instagramLink.isEmpty {
      Rectangle()
        .foregroundStyle(Color.black)
        .frame(width:1,height: 12)
        Button(action: {
          if let url = URL(string: instagramLink) {
            UIApplication.shared.open(url)
          }
        }) {
          Image("instagram")
            .aspectRatio(contentMode: .fill)
            .frame(width: 20, height: 20)
        }
      }
    }
  }
  
  private var aboutSection: some View {
    Group {
      if let about = social.about {
        Text("(\(about))")
          .font(CustomFont.aboutStyle)
          .foregroundColor(.gray)
      }
    }
  }
  
  private var followersAndFollowings: some View {
    HStack {
      VStack {
        Text("\(socialVM.followers.count)")
          .font(.system(size: 18))
          .fontWeight(.bold)
        Text("Followers")
          .font(.caption)
          .foregroundColor(.gray)
      }
      Spacer()
      VStack {
        Text("\(socialVM.followings.count)")
          .font(.system(size: 18))
          .fontWeight(.bold)
        Text("Following")
          .font(.caption)
          .foregroundColor(.gray)
      }
    }
    .padding(.horizontal, 116)
    .padding(.vertical, 5)
    .onTapGesture {
      appCoordinator.push(.followerView(followingsSocial: socialVM.followings, follwersSocial: socialVM.followers, currentUser: social))
    }
  }
  
  private var followButton: some View {
    Button {
      if let userId = social._id, let token = TokenManager.share.getToken() {
        userFollowVM.followUser(userId: userId, token: token)
      }
    } label: {
      if userFollowVM.followedButtonClicked || socialVM.alreadyFollowing {
        Text("Following")
          .foregroundStyle(Color.black)
          .fontWeight(.semibold)
          .font(.subheadline)
          .padding(.horizontal, 40)
          .padding(.vertical, 4)
          .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black,lineWidth: 1))
      } else if !userFollowVM.followedButtonClicked {
        Text("Follow")
          .foregroundStyle(Color.white)
          .fontWeight(.semibold)
          .font(.subheadline)
          .padding(.horizontal, 40)
          .padding(.vertical, 4)
          .background(RoundedRectangle(cornerRadius: 8).foregroundStyle(Color.black))
      }
    }
  }
  
  private var bio: some View {
    Text(social.bio ?? "")
      .font(CustomFont.bioStyle)
      .foregroundColor(.gray)
  }
}
