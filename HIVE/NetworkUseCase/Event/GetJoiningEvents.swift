//
//  GetJoiningEvents.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 11/12/2024.
//

import Foundation

class GetJoiningEvents: APIManager {
  
  var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  typealias ModelType = EventResponse
  
  var methodPath: String {
    return "/user/joiningEvents/\(userId)"
  }
  
}
