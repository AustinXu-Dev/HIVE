//
//  Date.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 20/10/2024.
//

import Foundation

extension Date {
        // Converts the date into a format like "18 May"
        func toDayMonthString() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM"
            return dateFormatter.string(from: self)
        }
    
    
  
        
        // Initialize a date from a string in the "YY-MM-DD" format
        static func stringToDate(_ dateString: String) -> Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd"
            return dateFormatter.date(from: dateString)
        }
    
     func formatDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
     func formatTimeToString() -> String {
          let timeFormatter = DateFormatter()
          timeFormatter.dateFormat = "HH:mm" // Change to "hh:mm a" for 12-hour format with AM/PM
          timeFormatter.locale = Locale(identifier: "en_GB")
          return timeFormatter.string(from: self)
      }
    
}
