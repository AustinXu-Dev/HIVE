//
//  GetAllUser.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class GetAllUsers: APIManager {
    
    typealias ModelType = UsersResponse
    
    var methodPath: String {
        return "/users"
    }
}
