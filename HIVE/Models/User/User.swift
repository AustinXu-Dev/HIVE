//
//  User.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

// Top-level response model
struct UserResponse: Codable,Hashable {
    let success: Bool?
    let message: UserModel?
}

// Top-level response model
struct UsersResponse: Codable, Hashable {
    let success: Bool?
    let message: [UserModel]?
}

struct UpdatedUserResponse : Codable, Hashable {
    let success : Bool
    let message : String
    let user : UserModel
}


// User details model
struct UserModel: Codable, Hashable {
  let verificationImageUrl: String?
  let verficatiionStatus: String?
    let _id: String?
    let name: String?
    let email: String?
    let dateOfBirth: String?
    let gender: String?
    let profileImageUrl: String?
    let about: String?
    var bio: String?
    let instagramLink: String?
    let isOrganizer: Bool?
    let isSuspended: Bool?
}

