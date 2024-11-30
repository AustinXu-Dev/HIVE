//
//  GetAllUsersViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class GetAllUsersViewModel: ObservableObject {
    
    @Published var userData: [UserModel]? = nil
    @Published var errorMessage: String? = nil
    
    func getAllUsers() {
        errorMessage = nil
        let getAllUsers = GetAllUsers()
        getAllUsers.execute(getMethod: "GET", token: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userData):
                    self.userData = userData.message
                case .failure(let error):
                    self.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                }
            }
        }
    }
  
  //refactor later
  func getAllUsersAsynchronously() async throws {
      return try await withCheckedThrowingContinuation { continuation in
          self.errorMessage = nil
          let getAllUsers = GetAllUsers()
          getAllUsers.execute(getMethod: "GET", token: nil) { result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let userData):
                      self.userData = userData.message
                      print("All Users fetched successfully")
                      continuation.resume()
                  case .failure(let error):
                      self.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                      continuation.resume(throwing: error)
                  }
              }
          }
      }
  }


  
}
