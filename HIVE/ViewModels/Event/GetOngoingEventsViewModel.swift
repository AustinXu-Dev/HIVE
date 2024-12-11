import Foundation


@MainActor
final class GetOngoingEventsViewModel: ObservableObject {
  
  
  @Published var organizingEvents: [EventModel] = []
  @Published var joiningEvents: [EventModel] = []
  @Published var errorMessage: String? = nil
  @Published var isLoading: Bool = false
  @Published var organizingPrivateEvents: [EventModel] = []

  
  
  
  init(){
    if let userId = KeychainManager.shared.keychain.get("appUserId"), let token = TokenManager.share.getToken() {
      getOrganizingEventsOfUser(userId: userId, token: token)
      getJoiningEventsOfUser(userId: userId, token: token)
      print("Fetch successfull")
      print(joiningEvents)
    }
  }
  
  func filerPrivateEvents(event: [EventModel]) -> [EventModel] {
    return event.filter({$0.isPrivate ?? false})
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
        DispatchQueue.main.async {
          self?.organizingEvents = response.message
          self?.organizingPrivateEvents = self?.filerPrivateEvents(event: self?.organizingEvents ?? []) ?? []
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  
  func getJoiningEventsOfUser(userId: String,token: String){
    DispatchQueue.main.async {
      self.isLoading = true
    }
    let organizingEventUseCase =  GetJoiningEvents(userId: userId)
    organizingEventUseCase.execute(getMethod: "GET", token: token) { [weak self] result in
      DispatchQueue.main.async {
        self?.isLoading = false
      }
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self?.joiningEvents = response.message
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.errorMessage = error.localizedDescription
        }
      }
    }
  }
  
}
