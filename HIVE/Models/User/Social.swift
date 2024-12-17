//
//  Social.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 15/12/2024.
//

import Foundation


struct FollowerResponse: Codable, Hashable {
  let success: Bool
  let followers: [UserModel]
}


struct FollowingResponse: Codable, Hashable {
  let success: Bool
  let following: [UserModel]
}



//struct SocialModel: Codable, Hashable {
//  let id: String
//  let name: String
//  let profileImageUrl: String
//  var bio: String
//}
