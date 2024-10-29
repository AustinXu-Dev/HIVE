//
//  UpdateUser.swift
//  HIVE
//
//  Created by Akito Daiki on 24/10/2024.
//

import Foundation

class UpdateUser: APIManager {
    
    typealias ModelType = UpdatedUserResponse
    var id: String
    
    init(id: String){
        self.id = id
    }
    
    var methodPath: String {
        return "/user/\(id)"
    }
}
