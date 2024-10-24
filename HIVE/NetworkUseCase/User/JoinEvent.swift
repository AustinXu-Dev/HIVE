//
//  JoinEvent.swift
//  HIVE
//
//  Created by Akito Daiki on 24/10/2024.
//

import Foundation

class JoinEvent: APIManager {
    
    typealias ModelType = JoinEventResponse
    var eventId: String
    
    init(eventId: String){
        self.eventId = eventId
    }
    
    var methodPath: String {
        return "/event/join/\(eventId)"
    }
}

