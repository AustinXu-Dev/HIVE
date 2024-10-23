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
    
    func formatDateString(toFormat format: String = "MMM d") -> String? {
            let dateFormatter = DateFormatter()
            
            // Specify the date format of the input string
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this to the format of your input string
            
            // Convert the string to a Date object
            guard let date = dateFormatter.date(from: self) else {
                return nil // Return nil if the string is not a valid date
            }
            
            // Specify the desired output format
            dateFormatter.dateFormat = format
            
            // Convert the Date object back to the formatted string
            return dateFormatter.string(from: date)
        }

}
