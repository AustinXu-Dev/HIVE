//
//  GetOneEventById.swift
//  HIVE
//
//  Created by Phyu Thandar Khin on 19/12/24.
//

import Foundation

class GetOneEventById: APIManager{
    typealias ModelType = OneEventResponse
    
    var id: String
    
    init(id: String){
        self.id = id
    }
    
    var methodPath: String{
        return "/event/\(id)"
    }
}
