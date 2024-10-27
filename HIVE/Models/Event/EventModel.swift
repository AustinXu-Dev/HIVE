//
//  EventModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import Foundation


struct EventResponse : Codable, Hashable {
    let success : Bool
    let message : [EventModel]
}

struct OneEventResponse : Codable, Hashable{
    let success : Bool
    let message : EventModel
}



struct EventModel : Codable, Hashable {

    let  _id,eventImageUrl,name,location: String
    let startDate,endDate,startTime,endTime : String
    let maxParticipants : Int
    let isLimited : Bool
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
 const eventSchema = new mongoose.Schema({
   eventImageUrl: {
     type: String,
     default: '',
   },
   name: {
     type: String,
     required: true,
   },
   location: {
     type: String,
     required: true,
   },
   startDate: {
     type: Date,
     required: true,
   },
   endDate: {
     type: Date,
     required: true,
   },
   startTime: {
     type: Date,
     required: true,
   },
   endTime: {
     type: Date,
     required: true,
   },
   maxParticipants: {
     type: Number,
     default: 0,
   },
   isLimited: {
     type: Boolean,
     default: false,
   },
   category: {
     type: Array,
     required: true,
   },
   additionalInfo: {
     type: String,
     default: '',
   },
   participants: {
     type: Array,
     default: [],
   },
   organizer: {
     type: String,
     required: true,
   },
 })
 */

