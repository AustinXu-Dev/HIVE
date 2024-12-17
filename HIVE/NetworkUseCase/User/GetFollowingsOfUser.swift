

import Foundation

class GetFollowingsOfUser: APIManager {

  var userId: String
  
  init(userId: String) {
    self.userId = userId
  }
  
  typealias ModelType = FollowingResponse
  
  var methodPath: String {
    return "/user/\(userId)/following"
  }
  
  
}
