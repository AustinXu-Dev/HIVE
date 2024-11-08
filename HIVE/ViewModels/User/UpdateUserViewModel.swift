//
//  UpdateUserViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 24/10/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class UpdateUserViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: String = ""
    @Published var gender: String = ""
    @Published var profileImageUrl: String = ""
    @Published var about: String = ""
    @Published var bio: String = ""
    @Published var instagramLink: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init(name: String = "", email: String = "", dateOfBirth: String = "", gender: String = "", profileImageUrl: String = "", about: String = "", bio: String = "", instagramLink: String = "", password: String = "") {
        self.name = name
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.profileImageUrl = profileImageUrl
        self.about = about
        self.bio = bio
        self.instagramLink = instagramLink
        self.password = password
    }

    func updateUser(id: String, token: String) {
        var updatedUserInfo: [String: String] = [:]

        if !name.isEmpty {
            updatedUserInfo["name"] = name
        }
        if !email.isEmpty {
            updatedUserInfo["email"] = email
        }
        if !dateOfBirth.isEmpty {
            updatedUserInfo["dateOfBirth"] = dateOfBirth
        }
        if !gender.isEmpty {
            updatedUserInfo["gender"] = gender
        }
        if !profileImageUrl.isEmpty {
            updatedUserInfo["profileImageUrl"] = profileImageUrl
        }
        if !about.isEmpty {
            updatedUserInfo["about"] = about
        }
        if !bio.isEmpty {
            updatedUserInfo["bio"] = bio
        }
        if !instagramLink.isEmpty {
            updatedUserInfo["instagramLink"] = instagramLink
        }
        if !password.isEmpty {
            updatedUserInfo["password"] = password
        }

        let updateUser = UpdateUser(id: id)
        isLoading = true
        errorMessage = nil

        updateUser.execute(data: updatedUserInfo, getMethod: "PUT", token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(_):
                    print("Successfully updated user profile")
                case .failure(let error):
                    self?.errorMessage = "Failed to update user: \(error.localizedDescription)"
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func storeImageUrl(imageUrl: String, uid: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("profiles").document(uid)
        
        userRef.setData([
            "imageUrl": imageUrl,
            "email": email
        ], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func retrieveImageUrl(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("profiles").document(uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let imageUrl = document.data()?["imageUrl"] as? String {
                    completion(.success(imageUrl))
                } else {
                    completion(.failure(NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Image URL not found"])))
                }
            } else {
                completion(.failure(NSError(domain: "Firestore", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        isLoading = true
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])))
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }

}
