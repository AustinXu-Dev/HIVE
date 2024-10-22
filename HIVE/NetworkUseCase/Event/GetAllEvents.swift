//
//  GetAllEvents.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation

class GetAllEvents : APIManager {
    typealias ModelType = EventResponse
    
    var methodPath: String {
        return "/events"
    }
    
    
}
