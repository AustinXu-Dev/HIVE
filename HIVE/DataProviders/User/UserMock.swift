//
//  UserMock.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import Foundation

struct UserMock {
    static let instance = UserMock()
    private init(){}
    
    let userA = UserModel(_id: "1", name: "Ko Shine", email: "shineshine@gmail.com", password: "mgshinemmsp", date_of_birth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false)
    
    
    let userB = UserModel(_id: "2", name: "Austin", email: "nwrgyi@gmail.com", password: "syr nwr", date_of_birth: "mogok", gender: "chigga", profileImageUrl: "winter", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false)
    
    let userC = UserModel(_id: "3", name: "Ko Shine", email: "shineshine@gmail.com", password: "mgshinemmsp", date_of_birth: "6 gwae", gender: "nigga", profileImageUrl: "giselle", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false)
    
    
    let userD = UserModel(_id: "4", name: "Austin", email: "nwrgyi@gmail.com", password: "syr nwr", date_of_birth: "mogok", gender: "chigga", profileImageUrl: "ningning", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false)
    
    
    let users = [
        UserModel(_id: "1", name: "Ko Shine", email: "shineshine@gmail.com", password: "mgshinemmsp", date_of_birth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false),
        UserModel(_id: "2", name: "Austin", email: "nwrgyi@gmail.com", password: "syr nwr", date_of_birth: "mogok", gender: "chigga", profileImageUrl: "winter", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false),
        
        UserModel(_id: "3", name: "Ko Shine", email: "shineshine@gmail.com", password: "mgshinemmsp", date_of_birth: "6 gwae", gender: "nigga", profileImageUrl: "giselle", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false),
        UserModel(_id: "4", name: "Austin", email: "nwrgyi@gmail.com", password: "syr nwr", date_of_birth: "mogok", gender: "chigga", profileImageUrl: "ningning", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false),
        UserModel(_id: "5", name: "Ko Shine", email: "shineshine@gmail.com", password: "mgshinemmsp", date_of_birth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false)
    ]
    
    
}

