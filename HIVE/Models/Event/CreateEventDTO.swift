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
