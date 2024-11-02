//
//  ProfileView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 20/10/2567 BE.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    var profile : ParticipantModel? = nil
    
    @State private var profileImage: UIImage? = nil
    @State private var isEditingDescription = false
    @State private var isEditingProfileImage = false
    @State private var descriptionText = ""
    @State private var editedDescriptionText = ""
    @State private var showImagePicker = false
    @State private var isEditable = true
    @State private var showLogoutAlert = false
    @State private var isCurrentUserProfile : Bool = true
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()
    @StateObject var profileVM = GetOneUserByIdViewModel()
    @StateObject var updateProfileVM = UpdateUserViewModel()
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl

    
    var body: some View {
        VStack(spacing: 20) {
            // Header with Back Button and Edit Options
            HStack {
                if !isCurrentUserProfile {
                    Button(action: {
                        appCoordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                                Spacer()
                
                if isEditingDescription && isCurrentUserProfile {
                    Button(action: {
                        descriptionText = editedDescriptionText
                        updateProfile()
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
            
            // Profile Image Section
            ZStack {
                if let selectedImage = profileImage {
                    // Show the selected image immediately
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .opacity(isEditingProfileImage ? 0.5 : 1.0)
                } else {
                    if isCurrentUserProfile {
                        KFImage(URL(string: profileVM.userDetail?.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .opacity(isEditingProfileImage ? 0.5 : 1.0)
                    } else {
                        KFImage(URL(string: profile?.profileImageUrl ?? ""))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .opacity(isEditingProfileImage ? 0.5 : 1.0)
                    }
                }
                
                if isEditable && isEditingProfileImage && isCurrentUserProfile {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(Color.black.opacity(0.7)))
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $profileImage)
            }
            
            // Profile Name and Description
            Text(isCurrentUserProfile ? profileVM.userDetail?.name ?? "Unknown" : profile?.name ?? "Unknown")
                .font(.title2)
                .fontWeight(.bold)
            if let about = profileVM.userDetail?.about, isCurrentUserProfile {
                Text("(\(about))")
                    .foregroundColor(.gray)
            } else {
            
//            if !isCurrentUserProfile {
                Text("(\(profile?.bio ?? ""))")
                    .foregroundColor(.gray)
            }
            
            if isEditingDescription {
                TextField("Enter New Bio", text: Binding(
                    get: { profileVM.userDetail?.bio ?? "" },
                    set: { profileVM.userDetail?.bio = $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
            } else {
                Text(isCurrentUserProfile ? profileVM.userDetail?.bio ?? "No bio available" : "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // Connect Button
            Button(action: {
                if let url = URL(string: profileVM.userDetail?.instagramLink ?? "") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "camera")
                        .foregroundColor(.pink)
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
            
            Spacer()
            
            // Logout Button
            
            if isCurrentUserProfile {
            Button {
                showLogoutAlert = true
            } label: {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                    .padding(.bottom,20)
            }
            .padding(.top,30)
            
        }
        }
        
        .onAppear(perform: {
           
           
            guard let reterivedUserId = KeychainManager.shared.keychain.get("appUserId") else { return }
            //by default,if userid is nil (meaning the partipant view is not initalized,assign profile userId as current User id
            if profile?.userid != nil {
                isCurrentUserProfile = false
            }
            //but the value will be the passed data if its pass from event participants view
            if profile?.userid != reterivedUserId {
                print("profile userId: \(profile?.userid)")
                print("reterived userID: \(reterivedUserId)")
                profileVM.getOneUserById(id: reterivedUserId)
                    
            }


        })
        
        
    
        
        .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                googleVM.signOutWithGoogle()
            }
        }
        .refreshable {
            refreshProfile()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Private Methods
    
    private func updateProfile() {
        
        guard let uid = KeychainManager.shared.keychain.get("appUserId"), let email = profileVM.userDetail?.email else { return }
        
        updateProfileVM.uploadImage(profileImage ?? UIImage(named: "profile")!) { result in
            switch result {
            case .success(let imageURL):
                storeImageUrlAndRetrieveImage(uid: uid, email: email, imageUrl: imageURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func storeImageUrlAndRetrieveImage(uid: String, email: String, imageUrl: String) {
        updateProfileVM.storeImageUrl(imageUrl: imageUrl, uid: uid, email: email) { result in
            switch result {
            case .success(_):
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
                guard let userBio = profileVM.userDetail?.bio else { return }
                updateProfileVM.profileImageUrl = storedImageUrl
                updateProfileVM.bio = userBio
                if let userToken = TokenManager.share.getToken() {
                    print("Token is \(userToken)")
                    updateProfileVM.updateUser(id: uid, token: userToken)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func refreshProfile() {
        if let userId = KeychainManager.shared.keychain.get("appUserId") {
            profileVM.getOneUserById(id: userId)
        }
    }
}


#Preview {
    ProfileView()
}
