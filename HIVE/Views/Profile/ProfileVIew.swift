//
//  ProfileView.swift
//  HIVE
//
//  Created by Kelvin Gao on 20/10/2567 BE.
//

import SwiftUI
import Kingfisher

class ProfileEditViewModel: ObservableObject {
    @Published var editedDescriptionText: String = ""
    @Published var isEditingProfileImage: Bool = false
    @Published var isEditingDescription: Bool = false
}

struct ProfileView: View {
    
    @StateObject var profileEditVM = ProfileEditViewModel()
    @State private var profileImage: UIImage? = nil
    @State private var isEditingDescription = false
    @State private var isEditingProfileImage = false
    @State private var descriptionText = ""
    @State private var editedDescriptionText = ""
    @State private var instagramLink = ""
    @State private var editedInstagramLink: String = ""
    @State private var showImagePicker = false
    @State private var isEditable = true
    @State private var showLogoutAlert = false
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()
    @EnvironmentObject var profileVM : GetOneUserByIdViewModel
    @StateObject var updateProfileVM = UpdateUserViewModel()
    @EnvironmentObject var socialVM: GetSocialViewModel
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @Environment(\.isGuest) private var isGuest: Bool
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
  @EnvironmentObject var eventHistoryVM: EventHistoryViewModel
    @FocusState private var isFocused: Bool
    @State private var showBioEditSheet = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(edges: .all)
            if isGuest {
                VStack(spacing: 20) {
                    Text("Please create or log in to an existing account")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Button {
                        userAppState =  AppState.notSignedIn.rawValue
                        
                    } label: {
                        ReusableAccountCreationButton()
                    }
                    
                    Text("To join or host your own!")
                        .bold()
                    
                }
            } else if profileVM.isLoading || updateProfileVM.isLoading {
                ProgressView()
            } else {
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            if isEditingDescription  {
                                if (profileImage != nil && isEditingProfileImage) ||
                                    (descriptionText != editedDescriptionText) ||
                                    (instagramLink != editedInstagramLink) {
                                    Button(action: {
                                        descriptionText = editedDescriptionText
                                        updateProfile()
                                        isEditingDescription = false
                                        isEditingProfileImage = false
                                    }) {
                                        Text("Confirm")
                                            .font(.callout)
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Button(action: {
                                        isEditingDescription = false
                                        isEditingProfileImage = false
                                    }) {
                                        Text("Cancel")
                                            .font(.callout)
                                            .foregroundColor(.red)
                                    }
                                }
                            } else if isEditable {
                                Button(action: {
                                    showBioEditSheet = true
                                }) {
                                    Image(systemName: "gearshape")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Divider()
                        
                        ZStack {
                            if let selectedImage = profileImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                    .opacity(isEditingProfileImage ? 0.5 : 1.0)
                            } else {
                                ZStack(alignment:.bottomTrailing){
                                    KFImage(URL(string: profileVM.userDetail?.profileImageUrl ?? ""))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                        .opacity(isEditingProfileImage ? 0.5 : 1.0)
                                    
                                  //hide the checkmark in edit mode
                                  if profileVM.userDetail?.verificationStatus == VertificationEnum.approved.rawValue && !profileEditVM.isEditingDescription && !profileEditVM.isEditingProfileImage {
                                        Image(systemName: "checkmark.seal.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:30,height:30)
                                            .foregroundColor(.blue)
                                            .offset(y:-5)
                                    }
                                }
                            }
                            
                            if isEditable && isEditingProfileImage  {
                                
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    Image(systemName: "pencil")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(50)
                                        .background(Circle().fill(Color.black.opacity(0.7)))
                                }
                            }
                            Image("Approval")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 52, height: 49)
                                .offset(x: 50, y: 45)
                        }
                        .sheet(isPresented: $showImagePicker) {
                            PhotoPicker(selectedImage: $profileImage, cropSize: nil)
                        }
                        
                        HStack {
                            Text(profileVM.userDetail?.name ?? "")
                                .body4()
                                .fontWeight(.bold)
                            
                            if let instagramLink = profileVM.userDetail?.instagramLink, !instagramLink.isEmpty {
                                Text("|")
                                    .font(.system(size: 18))
                                
                                Button(action: {
                                    if let url = URL(string: instagramLink) {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Image("instagram")
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 27, height: 27)
                                }
                            }
                            
                        }
                        
                        if let about = profileVM.userDetail?.about {
                            Text("(\(about))")
                                .light4()
                                .foregroundColor(.gray)
                        }
                        
                        if !isEditingDescription || !isEditingProfileImage {
                            HStack {
                                VStack {
                                    Text("\(socialVM.followers.count)")
                                        .body5()
                                        .fontWeight(.bold)
                                    Text("Followers")
                                        .light3()
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack {
                                    Text("\(socialVM.followings.count)")
                                        .body5()
                                        .fontWeight(.bold)
                                    Text("Following")
                                        .light3()
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 116)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                if let currentUser = profileVM.userDetail {
                                    appCoordinator.push(.followerView(followingsSocial: socialVM.followings, follwersSocial: socialVM.followers, currentUser: currentUser))
                                }
                            }
                        }
                        
                        VStack(spacing: 20) {
                            
                            if isEditingDescription {
                                TextField("Enter New Bio", text: $editedDescriptionText)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(height: 1)
                                            .offset(y: 15)
                                       
                                    )
                                    .focused($isFocused)
                                    .padding(.horizontal, 20)
                                    .onAppear {
                                        editedDescriptionText = profileVM.userDetail?.bio ?? ""
                                    }
                            } else {
                                Text(profileVM.userDetail?.bio ?? "")
                                    .light4()
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if isEditingDescription || isEditingProfileImage {
                                    Text("Instagram Profile URL")
                                        .font(.system(size: 16, weight: .medium))
                                        .padding(.horizontal, 10)
                                        .foregroundColor(.gray)
                                    
                                    TextField("Enter Instagram Link", text: $editedInstagramLink)
                                        .padding(10)
                                        .background(Color(UIColor.systemGray5).opacity(0.5))
                                        .cornerRadius(31)
                                        .focused($isFocused)
                                        .padding(.horizontal, 10)
                                        .onAppear {
                                            editedInstagramLink = profileVM.userDetail?.instagramLink ?? ""
                                        }
                                }
                            }
                        }
                        .padding()
                        
                        if !isEditingDescription || !isEditingProfileImage {
                            EventHistory(viewModel:eventHistoryVM)
                        }
                        
                      /*
                        Button {
                            showLogoutAlert = true
                        } label: {
                            Text("Logout")
                                .font(CustomFont.onBoardingButton)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                                .padding(.horizontal, 40)
                                .padding(.bottom,20)
                        }
                        .padding(EdgeInsets(top: 60, leading: 0, bottom: 20, trailing: 0))
                      */
                    }
                }
                .multilineTextAlignment(.center)
//                .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
//                    Button("Cancel", role: .cancel) {}
//                    Button("Logout", role: .destructive) {
//                        googleVM.signOutWithGoogle()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
//                            appCoordinator.setSelectedTab(index: .home)
//                        }
//                    }
//                }
                .refreshable {
                    refreshProfile()
                    if let userId = KeychainManager.shared.keychain.get("appUserId") {
                        socialVM.fetchUserData(userId: userId)
                        eventHistoryVM.getAllEventHistories(userId: userId)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    descriptionText = profileVM.userDetail?.bio ?? ""
                    instagramLink = profileVM.userDetail?.instagramLink ?? ""
                }
                .onChange(of: profileEditVM.isEditingDescription) { _,newValue in
                    if newValue {
                        isEditingDescription = true
                        isEditingProfileImage = profileEditVM.isEditingProfileImage
                    }
                }
            }
        }
        .sheet(isPresented: $showBioEditSheet) {
            SettingsView(profileEditVM: profileEditVM)
        }
        
        .onTapGesture {
            self.hideKeyboard()
        }
        
    }
    
    // MARK: - Private Methods
    
    private func updateProfile() {
        guard let uid = KeychainManager.shared.keychain.get("appUserId"),
              let userToken = TokenManager.share.getToken(),
              let email = profileVM.userDetail?.email else { return }
        
        if editedInstagramLink != profileVM.userDetail?.instagramLink {
            profileVM.userDetail?.instagramLink = editedInstagramLink
            updateProfileVM.instagramLink = editedInstagramLink
        }
        
        profileVM.userDetail?.bio = editedDescriptionText
        updateProfileVM.bio = editedDescriptionText
        if descriptionText == editedDescriptionText || instagramLink != editedInstagramLink {
            updateProfileVM.updateUser(id: uid, token: userToken) { result in
                switch result {
                case .success:
                    print("Profile updated successfully")
                    DispatchQueue.main.async {
                        descriptionText = editedDescriptionText
                        instagramLink = editedInstagramLink
                    }
                case .failure(let error):
                    print("Failed to update profile: \(error.localizedDescription)")
                }
            }
        }
        
        if let selectedImage = profileImage {
            updateProfileVM.uploadImage(selectedImage) { result in
                switch result {
                case .success(let imageURL):
                    storeImageUrlAndRetrieveImage(uid: uid, email: email, imageUrl: imageURL)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func storeImageUrlAndRetrieveImage(uid: String, email: String, imageUrl: String) {
        updateProfileVM.storeImageUrl(imageUrl: imageUrl, uid: uid, email: email) { result in
            switch result {
            case .success:
                retrieveImageURL(uid: uid)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func retrieveImageURL(uid: String) {
        updateProfileVM.retrieveImageUrl(uid: uid) { result in
            switch result {
            case .success(let storedImageUrl):
                print("Successfully retrieved image URL: \(storedImageUrl)")
                
                self.updateProfileVM.profileImageUrl = storedImageUrl
                
                guard let userToken = TokenManager.share.getToken() else {
                    print("Failed to retrieve user token")
                    return
                }
                
                self.updateProfileVM.updateUser(id: uid, token: userToken) { updateResult in
                    switch updateResult {
                    case .success:
                        print("Successfully updated user profile with new image URL")
                    case .failure(let error):
                        print("Failed to update user profile: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                print("Failed to retrieve image URL: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func refreshProfile() {
        if let userId = KeychainManager.shared.keychain.get("appUserId") {
            profileVM.getOneUserById(id: userId)
        }
    }
}


