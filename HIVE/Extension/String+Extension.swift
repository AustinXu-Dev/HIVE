//
//  String+Extension.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation

extension String {
    func to12HourFormat() -> String? {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm" // Input format
          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
          
          if let date = dateFormatter.date(from: self) {
              dateFormatter.dateFormat = "h a" // Output format
              return dateFormatter.string(from: date).lowercased()
          }
          return nil
      }
}
