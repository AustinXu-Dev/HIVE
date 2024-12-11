//
//  OnboardingViewModel.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore

class OnboardingViewModel: ObservableObject {
    // Published properties for each data point to be filled in the onboarding flow
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var gender: Gender = .diverse
    @Published var profileImage: UIImage?
    @Published var profileImageURL: String?
    @Published var bioType: BioType?
    @Published var bio: String = ""
    @Published var instagramHandle: String = ""
    @Published var verificationImage: UIImage?
    @Published var verficationImageURL: String?
    @Published var isUploading: Bool = false
    @Published var isPickerPresented = false
    
    func uploadProfileImage(uid: String, email: String) {
        guard let profileImage = profileImage, let imageData = profileImage.jpegData(compressionQuality: 0.8) else {
            print("Profile image data not available.")
            return
        }

        isUploading = true
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")

        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                self.isUploading = false
                return
            }

            // Retrieve the download URL after successful upload
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    self.isUploading = false
                    return
                }

                guard let downloadURL = url?.absoluteString else {
                    print("Failed to get the download URL.")
                    self.isUploading = false
                    return
                }

                // Store the download URL and email in Firestore
                let db = Firestore.firestore()
                let userRef = db.collection("profiles").document(uid)
                userRef.setData([
                    "imageUrl": downloadURL,
                    "email": email
                ], merge: true) { error in
                    if let error = error {
                        print("Error storing image URL in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image URL successfully stored in Firestore.")
                        self.profileImageURL = downloadURL

                    }
                    self.isUploading = false
                }
            }
        }
    }

    
    func uploadVerificationIamge(uid: String, email: String, completion: @escaping () -> Void) {
        guard let verificationImg = verificationImage, let imageData = verificationImg.jpegData(compressionQuality: 0.8) else {
            print("Verification image data not available.")
            return
        }

        isUploading = true
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")

        // Upload image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                self.isUploading = false
                return
            }

            // Retrieve the download URL after successful upload
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    self.isUploading = false
                    return
                }

                guard let downloadURL = url?.absoluteString else {
                    print("Failed to get the download URL.")
                    self.isUploading = false
                    return
                }

                // Store the download URL and email in Firestore
                let db = Firestore.firestore()
                let userRef = db.collection("verificationImages").document(uid)
                userRef.setData([
                    "imageUrl": downloadURL,
                    "email": email
                ], merge: true) { error in
                    if let error = error {
                        print("Error storing image URL in Firestore: \(error.localizedDescription)")
                    } else {
                        print("Image URL successfully stored in Firestore.")
                        self.verficationImageURL = downloadURL
                        completion()

                    }
                    self.isUploading = false
                }
            }
        }
    }


}
