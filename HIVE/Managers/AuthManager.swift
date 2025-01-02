
import Foundation
import FirebaseAuth
import SwiftUI

final class AuthenticationManager {
  
  static let shared = AuthenticationManager()
  var signInService = SignInService()
  var isNewUser: Bool = false
  var isWaitingForVerification: Bool = false
  @AppStorage("appState") private var userAppState: String = AppState.notSignedIn.rawValue
  @ObservedObject var getAllUserVM = GetAllUsersViewModel()
  var showAlert: Bool = false
  let tokenExpirationManager = TokenExpirationManager.shared //already init here
  
  
  private init(){}
  
  
  func createUser(email: String, password: String) async throws  {
    print("sign up invoked")
    do {
      try await Auth.auth().createUser(withEmail: email, password: password)
//      try await sendEmailVerification()
      print("sign up invoke success")
    } catch {
      throw error
    }
  }
  
  func signInUser(email: String, password: String) async throws  {
    print("sign in invoked")
    do {
      let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
      
    
      
      try await getAllUserVM.getAllUsersAsynchronously()

        guard let users = getAllUserVM.userData else {
          print("No users found")
          return }
        
        
        for user in users {
          
          if user.email == email {
            print("user exists in database")
            isNewUser = false
            signInService.email = authResult.user.email ?? ""
            signInService.password = authResult.user.uid
            signInService.signIn()
            
            tokenExpirationManager.saveTokenExpirationDate()
            userAppState = AppState.signedIn.rawValue
            return
          }
        }
        
        print("user not exists in database")
        isNewUser = true
        
      
    } catch {
      throw error
    }
    print("sign in invoke success")
  }
  
  
   func waitForEmailVerification() async throws {
      guard let user = Auth.auth().currentUser else {
          throw NSError(domain: "No current user", code: 0, userInfo: nil)
      }
      
      for _ in 0..<180 { // Retry for up to 3 minutes
          try await Task.sleep(nanoseconds: 2_000_000_000) // Wait 2 seconds
          try await user.reload()
          if user.isEmailVerified {
            isWaitingForVerification = false
              return
          }
      }
      
     isWaitingForVerification = false
      throw NSError(domain: "Email verification timeout", code: 1, userInfo: nil)
  }
  
  
  
  func sendEmailVerification() async throws {
    do {
      try await Auth.auth().currentUser?.sendEmailVerification()
      showAlert = true
      isWaitingForVerification = true
      //wait agani for 3 mins
      try await waitForEmailVerification()
    } catch {
      throw error
    }
  }
  
    func resetPassword(email: String) async throws {
      do {
        print("email sent to \(email)")
        try await Auth.auth().sendPasswordReset(withEmail: email)
      } catch {
        throw error
      }
    }
  
}
