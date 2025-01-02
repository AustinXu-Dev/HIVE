//
//  UserFollowViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 17/12/2024.
//

import Foundation

@MainActor
class UserFollowViewModel: ObservableObject {
  
  @Published var followSuccess: Bool = false
  @Published var errorMessage: String = ""
  @Published var followedButtonClicked: Bool = false
  @Published var showErrorAlert: Bool = false
  
  
  
  
  func followUser(userId:String,token:String){
    let useCase = UserFollowAnotherUser(userId: userId)
    useCase.execute(getMethod: "POST",token: token) { [weak self] result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.followSuccess = data.success
          self?.followedButtonClicked = true
        }
      case .failure(let error):
        self?.setUpErrorAlert(error: error.localizedDescription)
      }
    }
  }
  
  private func setUpErrorAlert(error: String){
    DispatchQueue.main.async {
      self.errorMessage = error
      self.showErrorAlert = true
    }
    
  }
}
