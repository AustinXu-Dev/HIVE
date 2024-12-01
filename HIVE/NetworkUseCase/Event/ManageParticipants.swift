//
//  ManageParticipants.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

class ManageParticipants : APIManager {
  var eventId: String
  var participantId: String
  
  
  init(eventId: String, participantId: String) {
    self.eventId = eventId
    self.participantId = participantId
  }
  
    typealias ModelType = ManageEventResponse
    
    var methodPath: String {
        return "/event/\(eventId)/manageParticipants/\(participantId)"
    }
  
}
