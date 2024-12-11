//
//  KickParticipants.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 10/12/2567 BE.
//

import Foundation

class KickParticipants: APIManager {
    typealias ModelType = KickParticipantResponse
    
    var eventId: String
    var participantId: String
    
    init(eventId: String, participantId: String) {
        self.eventId = eventId
        self.participantId = participantId
    }
    
    var methodPath: String{
        return "/event/\(eventId)/kickParticipants/\(participantId)"
    }
}
