//
//  GetOrganizedEvents.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation


class GetOrganizingEvents: APIManager {
  var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  
  typealias ModelType = EventHistoryResponse
  
  var methodPath: String {
    return "/user/organizingEvents/\(userId)"
  }
  
  
}

