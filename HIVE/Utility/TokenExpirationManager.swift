//
//  TokenExpirationManager.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 02/01/2025.
//

import Combine
import Foundation

@MainActor
final class TokenExpirationManager: ObservableObject {
  
  
  static let shared = TokenExpirationManager()
  
  @Published var tokenIsExpired : Bool = false
  var timer : AnyCancellable?
  var expirationDate : Date?
  
 private init() {
    loadTokenExpirationDate()
    startTokenExpiryCheck()
  }
  
  deinit {
    timer?.cancel()
  }
  
  func loadTokenExpirationDate() {
    if let savedExpirationDate = UserDefaults.standard.object(forKey: "TokenExpirationDate") as? Date {
      expirationDate = savedExpirationDate
      checkTokenExpiry()
    }
  }
  
  func checkTokenExpiry() {
    if let expirationDate = expirationDate {
      self.tokenIsExpired = Date() >= expirationDate
    }
  }
  
  func startTokenExpiryCheck() {
    // Set a timer to check every 3 hours
    timer = Timer.publish(every: 10800, on: .main, in: .common)

      .autoconnect()
      .sink { _ in
        self.checkTokenExpiry()
      }
  }
  
  func saveTokenExpirationDate(){
    let tokenReceivedDate = Date()
    self.expirationDate = Calendar.current.date(byAdding: .day, value: 1, to: tokenReceivedDate)
    UserDefaults.standard.set(self.expirationDate, forKey: "TokenExpirationDate")
    self.checkTokenExpiry()
  }
  
}


//after saving user id in UD,
/*
 // Save the token and expiration date (3 days from now)
 let tokenReceivedDate = Date()
 self.expirationDate = Calendar.current.date(byAdding: .day, value: 3, to: tokenReceivedDate)
 UserDefaults.standard.set(self.expirationDate, forKey: "TokenExpirationDate")
 self.checkTokenExpiry()
 */

// after, sign out
//UserDefaults.standard.removeObject(forKey: "TokenExpirationDate")
