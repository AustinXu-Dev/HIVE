//
//  EventMock.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/10/2024.
//

import Foundation

struct EventMock {
    static let instance = EventMock()
    private init(){}
    
    let eventA = EventModel(_id: "1", eventImageUrl: "event", name: "Mingle After Work ", location: "Ekkamai, St.889", startDate: "2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, minAge: 10, category: ["tech","business"], additionalInfo: "Hello this is test data for the event.", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer, pendingParticipants: ParticipantMock.instance.pendingParticipants)
    
    
//    let eventB = EventModel(_id: "2", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate: "2024-11-20", endDate: "2024-10-21", startTime: "20:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer)
//    
//    let eventC = EventModel(_id: "3", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate:"2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer)
//    
//    
//    let eventD = EventModel(_id: "4", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate: "2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer)
//    
//    let events = [
//        EventModel(_id: "1", eventImageUrl: "event", name: "Mingle After Work ", location: "Ekkamai, St.889", startDate: "2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["tech","business"], additionalInfo: "Hello this is test data for the event.", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer),
//        EventModel(_id: "2", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate: "2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer),
//        EventModel(_id: "3", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate:"2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer),
//        EventModel(_id: "4", eventImageUrl: "event", name: "Event No 2", location: "ABAC", startDate: "2024-10-21", endDate: "2024-10-21", startTime: "08:00", endTime: "10:00", maxParticipants: 20, isLimited: true, category: ["Business"], additionalInfo: "Hello", participants: ParticipantMock.instance.participants, organizer: OrganizerMock.instance.organizer)
//    ]
//    
}

