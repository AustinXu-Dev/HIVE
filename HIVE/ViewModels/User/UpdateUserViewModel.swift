//
//  UpdateUserViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 24/10/2024.
//

import Foundation

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
                    break
                case .failure(let error):
                    self?.errorMessage = "Failed to update user: \(error.localizedDescription)"
                }
            }
        }
    }
}
