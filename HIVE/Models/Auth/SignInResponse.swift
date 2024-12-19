//
//  SignInResponse.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

struct SignInResponse: Codable {
    let success: Bool
    let message: Message
}

struct Message: Codable {
    let token: String
    let user: User
}

struct User: Codable {
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
    let isSuspened: Bool
//    let verificationImageUrl: String
//    let verficatiionStatus: String
//    let password: String
//    let __v: Int
}
