//
//  EventHistoryViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 01/12/2024.
//

import Foundation

final class EventHistoryViewModel: ObservableObject {
  
  @Published var joinedEventHistory: [EventModel] = []
  @Published var hostedEventHistory: [EventModel] = []
  @Published var errorMessage: String? = ""
  @Published var isLoading : Bool = false
  private var loadingCount = 0 {
    didSet {
      DispatchQueue.main.async {
        self.isLoading = self.loadingCount > 0
      }
    }
  }
  
  
  
  init(userId:String){
    getAllEventHistories(userId: userId)
  }
  
  
  func getAllEventHistories(userId: String) {
     let dispatchGroup = DispatchGroup()
     incrementLoading()
     
     dispatchGroup.enter()
    getJoinedEventHistory(id: userId) {
         dispatchGroup.leave()
     }
     
     dispatchGroup.enter()
    getOrganizedEventHistory(id: userId) {
      dispatchGroup.leave()
    }
  
     
     dispatchGroup.notify(queue: .main) {
         self.decrementLoading()
         print("All data fetches are complete!")
     }
 }
  
  func getJoinedEventHistory(id: String,completion: @escaping () -> ()){
    incrementLoading()
    let eventJoinHistoryUseCase = JoinedEventHistory(id: id)
    eventJoinHistoryUseCase.execute(getMethod: "GET") { [weak self] result in
      DispatchQueue.main.async {
        self?.decrementLoading()
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
        print("ERROR OCCURED")
        print(self?.errorMessage ?? "")
      }
    }
    completion()
  }
  
  
  func getOrganizedEventHistory(id: String,completion: @escaping () -> ()){
    incrementLoading()
    let eventHostHistoryUsecase = OrganizedEventHistory(id: id)
    eventHostHistoryUsecase.execute(getMethod: "GET") { [weak self] result in
      DispatchQueue.main.async {
        self?.decrementLoading()
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
        print("ERROR OCCURED")
        print(self?.errorMessage ?? "")
      }
    }
    completion()
  }
  
  private func incrementLoading() {
        loadingCount += 1
    }
    
    private func decrementLoading() {
        loadingCount = max(loadingCount - 1, 0)
    }
  
}
