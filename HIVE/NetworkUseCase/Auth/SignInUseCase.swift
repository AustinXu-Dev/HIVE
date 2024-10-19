//
//  SignInUseCase.swift
//  HIVE
//
//  Created by Akito Daiki on 19/10/2024.
//

import Foundation

class SignInUseCase: APIManager {
    
    typealias ModelType = SignInResponse
    var methodPath: String {
        return "/auth/signin"
    }
}
