//
//  TextFieldValidationManager.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 30/11/2024.
//

import Foundation
struct TextFieldValidationManager {
  
  static func validateEmail(_ input: String) -> (TextFieldValidationError?, Bool) {
    if input.isEmpty {
      return (.missingEmail, false)
    }
    
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    if !emailTest.evaluate(with: input) {
      return (.invalidEmail, false)
    }
    
    return (nil, true)
  }
  
  static func validatePassword(_ input: String) -> (TextFieldValidationError?, Bool) {
      if input.isEmpty {
        return (.missingPassword, false)
      }
    
    let digitCount = input.filter { $0.isNumber }.count
       if input.count < 8 || digitCount < 3 {
           return (.passwordInvalid, false)
       }
       
       return (nil, true)

    }

  
}
