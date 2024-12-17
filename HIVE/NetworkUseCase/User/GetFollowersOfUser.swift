//
//  GetFollowerOfUser.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 15/12/2024.
//

import Foundation

class GetFollowersOfUser: APIManager {

  var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  typealias ModelType = FollowerResponse
  
  var methodPath: String {
    return "/user/\(userId)/follower"
  }
  
  
}

