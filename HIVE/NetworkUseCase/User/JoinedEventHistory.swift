//
//  JoinedEventHistory.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

class JoinedEventHistory: APIManager {
  var id: String
  
  init(id: String) {
    self.id = id
  }
  
  
  typealias ModelType = EventHistoryResponse
  
  var methodPath: String {
    return "/user/joinedEvents/\(id)"
  }
  
  
}
