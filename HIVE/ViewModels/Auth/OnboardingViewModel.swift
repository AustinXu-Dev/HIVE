//
//  OnboardingViewModel.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import Foundation
import SwiftUI
import FirebaseStorage

class OnboardingViewModel: ObservableObject {
    // Published properties for each data point to be filled in the onboarding flow
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var gender: Gender = .diverse
    @Published var profileImage: UIImage?
    @Published var profileImageURL: URL?
    @Published var bioType: Set<BioType> = []
    @Published var bio: String = ""
    @Published var instagramHandle: String = ""
    @Published var isUploading: Bool = false
    @Published var isPickerPresented = false
    
    func uploadProfileImage() {
        guard let imageData = profileImage?.jpegData(compressionQuality: 0.8) else { return }

        isUploading = true
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                self.isUploading = false
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                } else if let url = url {
                    self.profileImageURL = url
                }
                self.isUploading = false
            }
        }
    }
}
