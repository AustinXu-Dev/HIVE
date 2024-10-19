//
//  KeychainManager.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/19.
//

import Foundation
import KeychainSwift

class KeychainManager {
    
    static let shared = KeychainManager()
    
    let keychain = KeychainSwift()
    
    private init() {}
}
