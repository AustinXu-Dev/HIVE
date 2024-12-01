//
//  ManageEventViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

enum manageAction: String {
  case approve = "approve"
  case reject = "reject"
}

@MainActor
class ManageEventViewModel: ObservableObject {
  
  @Published var manageSuccessful: Bool = false
  @Published var isLoading : Bool = false
  @Published var errorMessage : String? = nil
  
  
  func manageUser(eventId: String, participantId:String, action: manageAction,token: String){
    isLoading = true
    let manageUserUseCase = ManageParticipants(eventId: eventId, participantId: participantId)
    let data = ManageParticipantDTO(action: action.rawValue)
    manageUserUseCase.execute(data: data, getMethod: "POST", token: token) { [weak self] result in
        DispatchQueue.main.async {
            self?.isLoading = false
        }
      switch result {
      case .success(let status):
          DispatchQueue.main.async {
              self?.manageSuccessful = status.success
              //set the hasApprovedOrReject to true
          }
        print("manage sucessful with status: \(self?.manageSuccessful ?? true)")
      case .failure(let error):
          DispatchQueue.main.async {
              self?.errorMessage = error.localizedDescription
          }
        print(self?.errorMessage ?? "")
      }
      
    }
  }
  
  
  
}
