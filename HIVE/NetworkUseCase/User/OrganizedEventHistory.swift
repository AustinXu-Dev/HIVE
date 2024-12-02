//
//  OrganizedEventHistory.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

class OrganizedEventHistory: APIManager {
  var id: String
  
  init(id: String) {
    self.id = id
  }
  
  
  typealias ModelType = EventResponse
  
  var methodPath: String {
    return "/user/organizedEvents/\(id)"
  }
  
  
}
