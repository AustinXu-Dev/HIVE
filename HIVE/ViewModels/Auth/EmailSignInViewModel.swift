//
//  EmailSignInViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 27/11/2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import SwiftUI

@MainActor
final class EmailSignInViewModel: ObservableObject {
  
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var errorMessage: String? = nil
  @Published var isNewUser: Bool = false
  @Published var isWaitingForVerification: Bool = false
  @Published var showAlert: Bool = false
  @Published var alertMessage: String = ""
  @Published var emailFieldErrorMessage: TextFieldValidationError? = nil
  @Published var passwordFieldErrorMessage: TextFieldValidationError? = nil
  @Published var emailFieldIsValid:Bool = false
  @Published var passwordFieldIsValid:Bool = false

  
  @Published var hasWaiting3Mintutes: Bool = false

  
  
  func handleAuthentication() async {
      do {
        //attempting to sign in
          try await signIn(email: email, password: password)
        
        // check email verification status
        if !isWaitingForVerification && isEmailVerified() {
          self.isNewUser = AuthenticationManager.shared.isNewUser
        } else {
          showEmailSentAlertBox()
          await sendEmailVerification()
          await waitingForVerification()
        }
      } catch let error as NSError {
        
        // if new user for firebase
          if shouldAttemptUserCreation(for: error.code) {
              do {
//                  showEmailSentAlertBox()
                try await createUser(email: email, password: password)
                try await Auth.auth().currentUser?.sendEmailVerification()
                alertMessage = "Verification email is sent to \(email)"
                showAlert = true
                isWaitingForVerification = AuthenticationManager.shared.isWaitingForVerification
                await waitingForVerification()
              } catch {
                errorMessage = error.localizedDescription
              }
          } else if error.code == AuthErrorCode.wrongPassword.rawValue {
              errorMessage = "Incorrect password."
          } else {
              errorMessage = error.localizedDescription
          }
      }
  }
  
  func resetPassword(email: String) async {
    do {
      try await AuthenticationManager.shared.resetPassword(email: email)
      showAlertForForgetPassword(email: email)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  //MARK: - Helper Methods

  
  func sendEmailVerification() async {
    do {
      try await AuthenticationManager.shared.sendEmailVerification()
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  private func createUser(email: String, password: String) async throws {
    do {
      try await AuthenticationManager.shared.createUser(email: email, password: password)
    } catch {
      throw error
    }
  }
  
  private func signIn(email: String, password: String) async throws {
    do {
      try await AuthenticationManager.shared.signInUser(email: email, password: password)
    } catch {
      throw error
    }
  }
  
  private func shouldAttemptUserCreation(for errorCode: Int) -> Bool {
      return errorCode == AuthErrorCode.userNotFound.rawValue ||
             errorCode == AuthErrorCode.invalidCredential.rawValue
  }
  
  private func isEmailVerified() -> Bool {
   return Auth.auth().currentUser?.emailVerified() ?? false
  }
  
  private func showEmailSentAlertBox() {
    alertMessage = "Verification email is sent to \(email)"
    showAlert = true
    
  }
  
  private func waitingForVerification() async {
    do {
      try await AuthenticationManager.shared.waitForEmailVerification()
      hasWaiting3Mintutes = true
      isWaitingForVerification = AuthenticationManager.shared.isWaitingForVerification
      self.isNewUser = !isWaitingForVerification && isEmailVerified()
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  private func showAlertForForgetPassword(email:String) {
    alertMessage = "Password reset email is sent to \(email)"
    showAlert = true
  }
  
}
