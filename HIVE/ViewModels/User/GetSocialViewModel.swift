//
//  GetSocialViewModel.swift
//  HIVE
//
//  Created by Swan Nay Phue Aung on 15/12/2024.
//

import Foundation

@MainActor
class GetSocialViewModel: ObservableObject {

  
  @Published var followers: [UserModel] = []
  @Published var followingsOfCurrentUser: [UserModel] = []
  @Published var followings: [UserModel] = []
  @Published var alreadyFollowing: Bool = false
  @Published var isLoading: Bool = false
  @Published var errorMessage: String = ""
  
  
  private var loadingCount = 0 {
    didSet {
      DispatchQueue.main.async {
        self.isLoading = self.loadingCount > 0
      }
    }
  }
  
  init(userId: String) {
    fetchUserData(userId: userId)
  }
  
   func fetchUserData(userId: String) {
      let dispatchGroup = DispatchGroup()
      incrementLoading()
      
      dispatchGroup.enter()
      getFollowingOfUser(userId: userId) {
          dispatchGroup.leave()
      }
      
      dispatchGroup.enter()
      getFollowersOfUser(userId: userId) {
          dispatchGroup.leave()
      }
      
      dispatchGroup.enter()
      getFollowingOfCurrentUser(toBeFollowedId: userId) {
          dispatchGroup.leave()
      }
      
      dispatchGroup.notify(queue: .main) {
          self.decrementLoading()
          print("All data fetches are complete!")
      }
  }
  
  
  func getFollowingOfUser(userId: String, completion:  @escaping () -> ()) {
    incrementLoading()
    let getFollowingUsecase = GetFollowingsOfUser(userId: userId)
    getFollowingUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.followings = data.following
        }
        print("fetch following success: \(data.following.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
        print(error.localizedDescription)
      }
    }
    completion()
  }
  
  func getFollowingOfCurrentUser(toBeFollowedId: String,completion:  @escaping () -> ()) {
    incrementLoading()
    guard let userId = KeychainManager.shared.keychain.get("appUserId") else {
      completion()
      return
    }
    let getFollowingUsecase = GetFollowingsOfUser(userId: userId)
    getFollowingUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.followingsOfCurrentUser = data.following
        }
        self?.checkFollowingStatus(following: data.following,toBeFollowedId: toBeFollowedId)
        print("fetch following success: \(data.following.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
        print(error.localizedDescription)
      }
    }
    completion()
  }
  
  
  func getFollowersOfUser(userId: String,completion:  @escaping () -> ()) {
    incrementLoading()
    let getFollowerUsecase = GetFollowersOfUser(userId: userId)
    getFollowerUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self?.followers = data.followers
        }
        print("fetch followers success: \(data.followers.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
        print(error.localizedDescription)

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
  
  
  func checkFollowingStatus(following:[UserModel],toBeFollowedId: String) {
    let alreadyFollowing = following.contains(where: {$0._id == toBeFollowedId})
    DispatchQueue.main.async {
      self.alreadyFollowing = alreadyFollowing
    }

    }
  
 

  
}

