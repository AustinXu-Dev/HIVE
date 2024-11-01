//
//  EventDTO.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

struct CreateEventDTO: Codable {
    let eventImageUrl: String
    let name: String
    let location: String
    let startDate: String
    let endDate: String
    let startTime: String
    let endTime: String
    let maxParticipants: Int
    let isLimited: Bool
    let category: [String]
    let additionalInfo: String
}


struct CreateEventResponse : Codable, Hashable{
    let success : Bool
    let message : CreatedEventModel
}



struct CreatedEventModel : Codable, Hashable {

    let  _id,eventImageUrl,name,location: String?
    let startDate,endDate,startTime,endTime : String?
    let maxParticipants : Int?
    let isLimited : Bool?
    let category : [String]?
    let additionalInfo : String?
//    let participants : [ParticipantModel]?
    let participants : [String]?
    let organizer : String?
}
