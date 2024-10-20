//
//  EventResponse.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

// Top-level response model
struct EventResponse: Codable {
    let success: Bool
    let message: EventDetails
}

// Event details model
struct EventDetails: Codable {
    let eventImageUrl: String
    let name: String
    let location: String
    let startDate: Date
    let endDate: Date
    let startTime: Date
    let endTime: Date
    let maxParticipants: Int
    let isLimited: Bool
    let category: [String]
    let additionalInfo: String
    let participants: [String]
    let organizer: String
}
