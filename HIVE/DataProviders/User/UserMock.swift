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
    
  let userA = UserModel(verificationImageUrl: "",verificationStatus: "",  _id: "1", name: "Ko Shine", email: "shineshine@gmail.com", dateOfBirth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false, isSuspended: false)
    
    
  let userB = UserModel(verificationImageUrl: "", verificationStatus: "", _id: "2", name: "Austin", email: "nwrgyi@gmail.com", dateOfBirth: "mogok", gender: "chigga", profileImageUrl: "winter", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false, isSuspended: false)
    
  let organizerUser = UserModel(verificationImageUrl: "",verificationStatus: "", _id: "3", name: "Ko Shine", email: "shineshine@gmail.com", dateOfBirth: "6 gwae", gender: "nigga", profileImageUrl: "giselle", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false, isSuspended: true)
    
    
  let suspendedUser = UserModel(verificationImageUrl:"",verificationStatus: "", _id: "4", name: "Austin", email: "nwrgyi@gmail.com", dateOfBirth: "mogok", gender: "chigga", profileImageUrl: "ningning", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: true, isSuspended: true)
    
    
    let users = [
      UserModel(verificationImageUrl: "",verificationStatus: "",  _id: "1", name: "Ko Shine", email: "shineshine@gmail.com", dateOfBirth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false, isSuspended: false),
      UserModel(verificationImageUrl: "", verificationStatus: "", _id: "2", name: "Austin", email: "nwrgyi@gmail.com", dateOfBirth: "mogok", gender: "chigga", profileImageUrl: "winter", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: false, isSuspended: false),
      UserModel(verificationImageUrl: "",verificationStatus: "", _id: "3", name: "Ko Shine", email: "shineshine@gmail.com", dateOfBirth: "6 gwae", gender: "nigga", profileImageUrl: "giselle", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false, isSuspended: true),
      UserModel(verificationImageUrl:"",verificationStatus: "", _id: "4", name: "Austin", email: "nwrgyi@gmail.com", dateOfBirth: "mogok", gender: "chigga", profileImageUrl: "ningning", about: "Chigga", bio: "Nwr Gyi is a chigga", instagramLink: "", isOrganizer: true, isSuspended: true),
      UserModel(verificationImageUrl: "",verificationStatus: "",  _id: "1", name: "Ko Shine", email: "shineshine@gmail.com", dateOfBirth: "6 gwae", gender: "nigga", profileImageUrl: "karina", about: "Nigga", bio: "Mg Shine is a nigga", instagramLink: "", isOrganizer: false, isSuspended: false)
    ]
    
    
}

