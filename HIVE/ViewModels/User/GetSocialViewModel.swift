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
    
    var followers: [UserModel] = []
    var followings: [UserModel] = []
    var followingsOfCurrentUser: [UserModel] = []
     
     
      dispatchGroup.enter()
      getFollowingOfUser(userId: userId) { returnedFollowings in
        followings = returnedFollowings
          dispatchGroup.leave()
      }
      
      dispatchGroup.enter()
      getFollowersOfUser(userId: userId) { returnedFollowers in
        followers = returnedFollowers
          dispatchGroup.leave()
      }
      
      dispatchGroup.enter()
      getFollowingOfCurrentUser(toBeFollowedId: userId) { returnedFollowingsOfCurrentUser in
        followingsOfCurrentUser = returnedFollowingsOfCurrentUser
          dispatchGroup.leave()
      }
      
      dispatchGroup.notify(queue: .main) {
        self.followers = followers
        self.followings = followings
        self.followingsOfCurrentUser = followingsOfCurrentUser
          self.decrementLoading()
          print("All data fetches are complete!")
      }
  }
  
  
  func getFollowingOfUser(userId: String, completion:  @escaping ([UserModel]) -> ()) {
    incrementLoading()
    let getFollowingUsecase = GetFollowingsOfUser(userId: userId)
    getFollowingUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          completion(data.following)
        }
        print("fetch following success: \(data.following.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
          completion([])
        }
        print(error.localizedDescription)
      }
    }
  }
  
  func getFollowingOfCurrentUser(toBeFollowedId: String,completion:  @escaping ([UserModel]) -> ()) {
    incrementLoading()
    guard let userId = KeychainManager.shared.keychain.get("appUserId") else {
      completion([])
      return
    }
    let getFollowingUsecase = GetFollowingsOfUser(userId: userId)
    getFollowingUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          completion(data.following)
        }
        self?.checkFollowingStatus(following: data.following,toBeFollowedId: toBeFollowedId)
        print("fetch following success: \(data.following.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
          completion([])
        }
        print(error.localizedDescription)
      }
    }
  }
  
  
  func getFollowersOfUser(userId: String,completion:  @escaping ([UserModel]) -> ()) {
    incrementLoading()
    let getFollowerUsecase = GetFollowersOfUser(userId: userId)
    getFollowerUsecase.execute(getMethod: "GET") { [weak self] result in
      self?.decrementLoading()
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          completion(data.followers)
        }
        print("fetch followers success: \(data.followers.count)")
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
          completion([])
        }
        print(error.localizedDescription)

      }
    }
    
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

