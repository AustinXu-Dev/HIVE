//
//  UserModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import Foundation


/*
 "name" : "noel",
  "email": "noel@gmail.com",
  "password": "123456",
  "date_of_birth": "1990-01-01",
"gender": "Male",
"profileImageUrl": "https://example.com/profile.jpg",
"about": "A short description about the user.",
"bio": "John is a software developer.",
"instagramLink": "https://instagram.com/johndoe",
"isOrganizer": false
 */
struct UserModel : Codable {
    let _id,name, email, password, date_of_birth ,gender ,profileImageUrl, about,bio : String?
    let instagramLink : String?
    let isOrganizer : Bool?
}

