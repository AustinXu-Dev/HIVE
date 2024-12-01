//
//  GetOngoingEventsViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation


@MainActor
final class GetOngoingEventsViewModel: ObservableObject {
  
  
  @Published var organizingEvents: [EventHistoryModel] = []
  @Published var errorMessage: String? = nil
  @Published var isLoading: Bool = false
  @Published var organizingPrivateEvents: [EventHistoryModel] = []

  
  
  func filerPrivateEvents(event: [EventHistoryModel]) -> [EventHistoryModel] {
    return event.filter({$0.isPrivate})
  }
  

  
  
  func getOrganizingEventsOfUser(userId: String,token: String){
    DispatchQueue.main.async {
      self.isLoading = true
    }
    let organizingEventUseCase =  GetOrganizingEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET", token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let response):
        self?.organizingEvents = response.message
        self?.organizingPrivateEvents = self?.filerPrivateEvents(event: self?.organizingEvents ?? []) ?? []
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
      }
    }
    
  }
  
}
