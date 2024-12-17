//
//  SignUpSchema.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

struct SignUpSchema: Codable {
    let name: String
    let email: String
    let dateOfBirth: String
    let gender: String
    let profileImageUrl: String
    let about: String
    let bio: String
    let instagramLink: String
    let verificationImageUrl: String
    let isOrganizer: Bool
    let isSuspened: Bool
    let password: String
}
