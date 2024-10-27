//
//  ProfileView.swift
//  HIVE
//
//  Created by Kelvin Gao  on 20/10/2567 BE.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State private var profileImage: UIImage? = UIImage(named: "profile")
    @State private var isEditingDescription = false
    @State private var isEditingProfileImage = false
    @State private var descriptionText = "Outgoing expat who loves nightlife 🌃"
    @State private var editedDescriptionText = ""
    @State private var showImagePicker = false
    @State private var isEditable = true
    @ObservedObject var googleVM = GoogleAuthenticationViewModel()

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()

                if isEditingDescription {
                    Button(action: {
                        descriptionText = editedDescriptionText
                        isEditingDescription = false
                        isEditable = false
                    }) {
                        Text("Done")
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                } else if isEditable {
                    Button(action: {
                        editedDescriptionText = descriptionText
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
                if let image = profileImage {
                    Image(uiImage: image)
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
                            .background(Circle().fill(Color.black.opacity(0.7)))
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .onTapGesture {
                if isEditable {
                    isEditingProfileImage.toggle()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $profileImage)
            }

            Text("Harley")
                .font(.title2)
                .fontWeight(.bold)

            Text("(Expat)")
                .foregroundColor(.gray)

            if isEditingDescription {
                TextField("Enter description", text: $editedDescriptionText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
            } else {
                Text(descriptionText)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button(action: {
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
            Button {
                googleVM.signOutWithGoogle()
            } label: {
                Text("Logout")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
}
