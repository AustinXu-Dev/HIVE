//
//  EventModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import Foundation



struct EventHistoryResponse: Codable,Hashable {
  let success : Bool
  let message : [EventHistoryModel]
}


struct EventHistoryModel : Codable, Hashable {
  let minAge : Int?
  let isPrivate: Bool?
  let pendingParticipants: [PendingParticipantModel]?
  let  _id,eventImageUrl,name,location: String?
  let startDate,endDate,startTime,endTime : String?
  let maxParticipants : Int?
  let category : [String]?
  let additionalInfo : String?
  let participants : [ParticipantModel]?
  let organizer : String?
}

struct EventResponse : Codable, Hashable {
  let success : Bool
  let message : [EventModel]
}

struct OneEventResponse : Codable, Hashable{
  let success : Bool
  let message : EventModel
}



struct EventModel : Codable, Hashable {
  let minAge : Int?
  let isPrivate: Bool?
  let pendingParticipants: [PendingParticipantModel]?
  let  _id,eventImageUrl,name,location: String
  let startDate,endDate,startTime,endTime : String
  let maxParticipants : Int
  let category : [String]
  let additionalInfo : String
  let participants : [ParticipantModel]?
  let organizer : OrganizerModel?
}

struct JoinEventResponse : Codable, Hashable{
  let success : Bool
  let message : String
}

/*
 // Event Schema
 "minAge": 0,
 "isPrivate": false,
 "pendingParticipants": [],
 "_id": "672cf5c204f76de99c562eed",
 "eventImageUrl": "https://firebasestorage.googleapis.com:443/v0/b/hive-42a18.appspot.com/o/images%2F4A1A4ED0-D457-474A-A494-066D9328C888.jpg?alt=media&token=5fefe64c-57e6-4435-b7ec-5ee2a0d8d90e",
 "name": "new test event",
 "location": "mucho",
 "startDate": "2024-11-09T00:15:00.000Z",
 "endDate": "2024-11-09T02:15:00.000Z",
 "startTime": "2024-11-09T00:15:00.000Z",
 "endTime": "2024-11-09T02:15:00.000Z",
 "maxParticipants": 100,
 "isLimited": false,
 "category": [
 "Casual",
 "Drinks",
 "Music"
 ],
 "additionalInfo": "Test",
 "participants": [],
 "organizer": "672cf4df04f76de99c562ee5",
 "__v": 0
 */


