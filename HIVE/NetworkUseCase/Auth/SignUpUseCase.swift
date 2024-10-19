//
//  SignUpUseCase.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

class SignUpUseCase: APIManager {
    
    typealias ModelType = SignUpResponse
    var methodPath: String {
        return "/auth/signup"
    }
}
