//
//  UserCreateEvent.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class UserCreateEventUseCase: APIManager {
    
    typealias ModelType = OneEventResponse
    var methodPath: String {
        return "/event/create"
    }
}
