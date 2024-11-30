import Foundation

enum TextFieldValidationError: String, Error {

  // MARK: Email Input Error

  case missingEmail = "You must fill the email address"
  case invalidEmail = "The email address is not valid"
  case missingPassword = "You must fill the password"
  case passwordInvalid = "The password must contain at least 8 charcaters and 3 digits"
  
}
