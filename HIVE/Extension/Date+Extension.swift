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
    
}
