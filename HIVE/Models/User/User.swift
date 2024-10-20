//
//  User.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

// Top-level response model
struct UserResponse: Codable {
    let success: Bool
    let message: UserDetails
}

// Top-level response model
struct UsersResponse: Codable {
    let success: Bool
    let message: [UserDetails]
}

// User details model
struct UserDetails: Codable {
    let _id: String
    let name: String
    let email: String
    let dateOfBirth: String
    let gender: String
    let profileImageUrl: String
    let about: String
    let bio: String
    let instagramLink: String
    let isOrganizer: Bool
    let isSuspended: Bool
}
