//
//  EventHistoryViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

final class EventHistoryViewModel: ObservableObject {
  
  
  @Published var joinedEventHistory: [EventHistoryModel] = []
  @Published var hostedEventHistory: [EventHistoryModel] = []
  @Published var errorMessage: String? = ""
  @Published var isLoading : Bool = false
  
  
  
  
  func getJoinedEventHistory(id: String,token: String){
    isLoading = true
    let eventJoinHistoryUseCase = JoinedEventHistory(id: id)
    eventJoinHistoryUseCase.execute(getMethod: "GET", token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let event):
        DispatchQueue.main.async {
          self?.joinedEventHistory = event.message
        }
        print("event joined hisotry success")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
        print(self?.errorMessage ?? "")
      }
    }
  }
  
  
  func getOrganizedEventHistory(id: String,token:String){
      isLoading = true
    let eventHostHistoryUsecase = OrganizedEventHistory(id: id)
    eventHostHistoryUsecase.execute(getMethod: "GET",token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let event):
        DispatchQueue.main.async {
          self?.hostedEventHistory = event.message
        }
        print("event hosted hisotry success")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
        print(self?.errorMessage ?? "")
      }
    }
  }

}
