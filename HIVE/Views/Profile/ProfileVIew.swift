//
//  ProfileView.swift
//  HIVE
//
//  Created by Kelvin Gao on 20/10/2567 BE.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @State private var profileImage: UIImage? = nil
    @State private var isEditingDescription = false
    @State private var isEditingProfileImage = false
    @State private var descriptionText = ""
    @State private var editedDescriptionText = ""
    @State private var showImagePicker = false
    @State private var isEditable = true
    @State private var showLogoutAlert = false
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()
    @EnvironmentObject var profileVM: GetOneUserByIdViewModel
    @StateObject var updateProfileVM = UpdateUserViewModel()
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @Environment(\.isGuest) private var isGuest: Bool
    @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
    
    @FocusState private var isFocused: Bool
    
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
                        userAppState = AppState.notSignedIn.rawValue
                    } label: {
                        ReusableAccountCreationButton()
                    }
                    
                    Text("To join or host your own!")
                        .bold()
                    
                }
            } else if profileVM.isLoading || updateProfileVM.isLoading {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            if isEditingDescription {
                                Button(action: {
                                    if profileImage != nil || descriptionText != editedDescriptionText {
                                        descriptionText = editedDescriptionText
                                        updateProfile()
                                    }
                                    isEditingDescription = false
                                    isEditingProfileImage = false
                                }) {
                                    Text("Done")
                                        .font(.callout)
                                        .foregroundColor(.black)
                                }
                            } else if isEditable {
                                Button(action: {
                                    editedDescriptionText = descriptionText
                                    isEditingProfileImage = true
                                    isEditingDescription = true
                                }) {
                                    Image(systemName: "pencil")
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
                                KFImage(URL(string: profileVM.userDetail?.profileImageUrl ?? ""))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                    .opacity(isEditingProfileImage ? 0.5 : 1.0)
                            }
                            
                            if isEditable && isEditingProfileImage {
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
                        .sheet(isPresented: $showImagePicker, onDismiss: {
                            if profileImage != nil {
                                updateProfile()
                            }
                        }) {
                            ImagePicker(selectedImage: $profileImage)
                        }

                        HStack {
                            Text(profileVM.userDetail?.name ?? "")
                                .font(CustomFont.profileTitle)
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
                                .font(CustomFont.aboutStyle)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            VStack {
                                Text("0")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                Text("Followers")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack {
                                Text("0")
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
                            appCoordinator.push(.followerView)
                        }
                        
                        if isEditingDescription {
                            TextField("Enter New Bio", text: $editedDescriptionText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .focused($isFocused)
                                .padding(.horizontal, 40)
                        } else {
                            Text(profileVM.userDetail?.bio ?? "")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        EventHistory()
                        
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
                                .padding(.bottom, 20)
                        }
                        .padding(EdgeInsets(top: 60, leading: 0, bottom: 20, trailing: 0))
                    }
                }
                .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Logout", role: .destructive) {
                        googleVM.signOutWithGoogle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            appCoordinator.selectedTabIndex = .home
                        }
                    }
                }
                .refreshable {
                    refreshProfile()
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                                    // Initialize descriptionText with backend data
                                    descriptionText = profileVM.userDetail?.bio ?? ""
                                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateProfile() {
        guard let uid = KeychainManager.shared.keychain.get("appUserId"),
              let email = profileVM.userDetail?.email else { return }
        
        guard let uid = KeychainManager.shared.keychain.get("appUserId"),
                      let userToken = TokenManager.share.getToken() else { return }

        
        // Update bio unconditionally
                profileVM.userDetail?.bio = editedDescriptionText
                updateProfileVM.bio = editedDescriptionText
                updateProfileVM.updateUser(id: uid, token: userToken) { result in
                    switch result {
                    case .success:
                        print("Bio updated successfully")
                        DispatchQueue.main.async {
                            descriptionText = editedDescriptionText
                        }
                    case .failure(let error):
                        print("Failed to update bio: \(error.localizedDescription)")
                    }
                }

        // Handle image update if necessary
        if let selectedImage = profileImage {
            updateProfileVM.uploadImage(selectedImage) { result in
                switch result {
                case .success(let imageURL):
                    storeImageUrlAndRetrieveImage(uid: uid, email: email, imageUrl: imageURL)
                case .failure(let error):
                    print("Failed to upload image: \(error.localizedDescription)")
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
                
                // Update the ViewModel with the retrieved URL
                self.updateProfileVM.profileImageUrl = storedImageUrl
                
                // Proceed to update the user profile
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

