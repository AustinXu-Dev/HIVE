//
//  UserFollowAnotherUser.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/12/2024.
//

import Foundation

class UserFollowAnotherUser: APIManager {
  typealias ModelType = FollowResponse
  
  var methodPath: String {
    return "/user/follow/\(userId)"
  }
  
  var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
}
