//
//  EventDTO.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

struct CreateEventDTO: Codable, Hashable {
    let eventImageUrl: String
    let name: String
    let location: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let maxParticipants: Int
    let category: [String]
    let additionalInfo: String
    let isPrivate: Bool
    let minAge: Int
}


struct CreateEventResponse : Codable, Hashable{
    let success : Bool
    let message : CreateEventDTO
}



struct CreatedEventModel : Codable, Hashable {

    let  _id,eventImageUrl,name,location: String?
    let startDate,endDate,startTime,endTime : String?
    let maxParticipants : Int?
    let minAge: Int?
    let category : [String]?
    let additionalInfo : String?
//    let participants : [ParticipantModel]?
    let participants : [String]?
    let isPrivate: Bool
    let pendingParticipants: [ParticipantModel]?
    let organizer : String?
}
